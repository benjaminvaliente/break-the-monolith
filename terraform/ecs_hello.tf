# hello app definition

data "template_file" "hello" {
  template = file("./templates/ecs/hello_tpl.json.tpl")

  vars = {
    app_image      = var.image_hello
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "hello" {
  family                   = "hello"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.hello.rendered
}

resource "aws_ecs_service" "hello" {
  name            = "hello-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

/*   load_balancer {
    target_group_arn = aws_alb_target_group.hello.id
    container_name   = "hello-app"
    container_port   = var.app_port
  } */

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
  #depends_on = [aws_alb_listener.app, aws_iam_role_policy_attachment.ecs_task_execution_role]
}