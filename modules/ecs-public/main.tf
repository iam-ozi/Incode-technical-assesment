# ----------------------------------
# ECS Cluster
# ----------------------------------
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# ----------------------------------
# ALB Security Group
# ----------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ----------------------------------
# Application Load Balancer
# ----------------------------------
resource "aws_lb" "this" {
  name               = "${var.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
  tags               = var.tags
}

# -------------------------------------
# Target Group
# -------------------------------------
resource "aws_lb_target_group" "public_tg" {
  name        = "${var.cluster_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = var.health_check_path
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  
  tags = var.tags
}

# ----------------------------------
# Listener
# ----------------------------------
resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}

# ----------------------------------------
# Task Execution Role
# ----------------------------------------
data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "${var.cluster_name}-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "exec_attach" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------------------
# CloudWatch Log Group
# ----------------------------------------
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.cluster_name}/${var.service_name}"
  retention_in_days = 7
  tags              = var.tags
}

# ----------------------------------------
# Task Definition
# ----------------------------------------
resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      portMappings = [{
        containerPort = var.container_port
        hostPort      = var.container_port
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.service_name
        }
      }
    }
  ])
  tags = var.tags
}

# ------------------------------------------
# Service & Autoscaling
# ------------------------------------------
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.public_tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.public_listener]
}

resource "aws_security_group" "service_sg" {
  name        = "${var.service_name}-sg"
  description = "SG for ${var.service_name} tasks"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow ALB"
    from_port        = var.container_port
    to_port          = var.container_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

# App Auto Scaling
resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${var.service_name}-cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.cpu_target_utilization
  }
}
