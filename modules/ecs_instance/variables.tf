variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  description = "The name of the cluster"
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "aws_ami" {
  description = "The AWS ami id to use"
  default     = ""
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "alb_security_group" {
  description = "ALB security group"
}

variable "instance_type" {
  description = "The type of the instance"
  default     = "t2.micro"
}

variable "instance_profile" {
  description = "Instance profile used by the instance"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume"
  default     = 30
}

variable "ebs_volume_type" {
  description = "Type of the EBS volume"
  default     = "gp2"
}

variable "key_name" {
  description = "Key to connect to the instance"
  default     = null
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}
