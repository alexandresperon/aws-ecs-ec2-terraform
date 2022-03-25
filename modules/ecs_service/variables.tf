variable "aws_region" {
  description = "Region where container will run"
}

variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "ECS cluster"
}

variable "service_name" {
  description = "The service name"
}

variable "container_name" {
  description = "The container name"
}

variable "load_balancer" {
  description = "Load Balancer ARN"
}

variable "protocol" {
  description = "Protocol used by the exposed service"
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "Certificate ARN for the ALB listener"
  default     = null
}

variable "exposed_port" {
  description = "The exposed port in ALB for the service"
  default     = 80
}

variable "container_port" {
  description = "The port used by the container"
  default     = 8080
}

variable "image" {
  description = "Container Docker image"
}

variable "entry_point" {
  type        = list(string)
  description = "Container Docker image"
  default     = []
}

variable "mount_points" {
  type = list(object({
    sourceVolume  = string,
    containerPath = string
  }))
  description = "Container Docker image"
  default     = []
}

variable "environment_vars" {
  type = list(object({
    name  = string,
    value = string
  }))
  description = "Container environment variables"
  default     = []
}

variable "volume" {
  type = list(object({
    name      = string,
    host_path = string
  }))
  description = "Volume mapped to the container"
  default     = []
}

variable "vpc_id" {
  description = "Id of the VPC"
}

variable "asg_subnets" {
  description = "The subnets associated with the ASG"
}

variable "launch_configuration" {
  description = "Launch configuration used by ASG"
}

variable "desired_count" {
  description = "Desired number of containers"
  default     = 1
}

variable "task_memory" {
  description = "Memory used by the task"
  default     = 512
}

variable "cloudwatch_prefix" {
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "max_size" {
  description = "Maximum number of instances in the ECS cluster."
  default     = 1
}

variable "min_size" {
  description = "Minimum number of instances in the ECS cluster."
  default     = 1
}

variable "desired_capacity" {
  description = "Ideal number of instances in the ECS cluster."
  default     = 1
}
