# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "far_log_group" {
  name              = "/ecs/fargate-app"
  retention_in_days = 1

  tags = {
    Name = "fargate-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "far_log_stream" {
  name           = "fargate-log-stream"
  log_group_name = aws_cloudwatch_log_group.far_log_group.name
}