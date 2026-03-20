# Create the internet-facing Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.name}-${var.environment}-alb"
  internal           = false                         # Internet-facing
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]       # ALB must be attached to a SG
  subnets            = var.subnet_ids                # Usually public subnets

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-alb"
  })
}

# Target group for forwarding traffic from the ALB
resource "aws_lb_target_group" "this" {
  name     = "${var.name}-${var.environment}-tg"
  port     = var.target_port                        # Port used by backend service
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path     # Path to check container or service health
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-tg"
  })
}

# HTTP listener that redirects to HTTPS (port 443) using 301 redirect
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
