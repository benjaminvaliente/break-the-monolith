# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "EcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "EcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "image_hello" {
  description = "Docker image to run in the ECS cluster"
  default     = "451535584409.dkr.ecr.us-east-1.amazonaws.com/hello:latest"
}

variable "image_user" {
  description = "Docker image to run in the ECS cluster"
  default     = "451535584409.dkr.ecr.us-east-1.amazonaws.com/user:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "80"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = "1"
}

variable "hc_path_hello" {
  default = "/hello"
}

variable "hc_path_user" {
  default = "/user"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "1024"
}