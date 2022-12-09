# alb.tf

resource "aws_alb" "main" {
  name            = "load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "app" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.hello.id
    type             = "forward"
  }
}


resource "aws_alb_target_group" "hello" {
  name        = "target-group-hello"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.hc_path_hello
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener_rule" "hello" {
  listener_arn = "${aws_alb_listener.app.arn}"
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.hello.arn}"
  }

  condition {
    path_pattern {
    values = ["/hello/*"]
    }
  }
  depends_on = [aws_ecs_service.hello]
}

/*
resource "null_resource" "ip_hello" {
  provisioner "local-exec" {
    command     = "export AWS_PROFILE='default'; chmod +x ./ip.sh; ./ip.sh ${aws_ecs_cluster.main.name} ${aws_ecs_service.hello.name}"
    interpreter = ["bash", "-c"]
  }
}

resource "aws_alb_target_group_attachment" "hello" {
  target_group_arn = aws_alb_target_group.hello.arn
  target_id        = aws_ecs_service.hello.id
}

resource "aws_alb_target_group" "user" {
  name        = "target-group-user"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.hc_path_user
    unhealthy_threshold = "2"
  }
}

resource "null_resource" "ip_user" {
  provisioner "local-exec" {
    command     = "export AWS_PROFILE='default'; chmod +x ./ip.sh; ./ip.sh ${aws_ecs_cluster.main.name} ${aws_ecs_service.user.name}"
    interpreter = ["bash", "-c"]
  }
}

resource "aws_alb_target_group_attachment" "hello" {
  target_group_arn = aws_alb_target_group.hello.arn
  target_id        = null_resource.ip_user.
}

resource "aws_alb_target_group_attachment" "user" {
  target_group_arn = aws_alb_target_group.user.arn
  target_id        = aws_ecs_service.user.id
}

resource "aws_alb_listener_rule" "user" {
  listener_arn = "${aws_alb_listener.app.arn}"
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.user.arn}"
  }

  condition {
    path_pattern {
    values = ["/user/*"]
    }
  }
  depends_on = [aws_ecs_service.user]
} */