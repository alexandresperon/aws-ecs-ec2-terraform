locals {
  aws_region     = "us-east-1"
  environment    = "development"
  vpc_id         = "vpc-id"
  subnets        = ["subnet-a", "subnet-b"]
  cluster_name   = "cluster-prod"
  instance_group = "ecs"
}

provider "aws" {
  region  = local.aws_region
  profile = "default"
}

module "alb" {
  source = "github.com/alexandresperon/aws-ecs-ec2-terraform/modules/alb"

  alb_name          = "keycloak-lb"
  environment       = local.environment
  public_subnet_ids = local.subnets
  vpc_id            = local.vpc_id
}

module "cluster" {
  source = "github.com/alexandresperon/aws-ecs-ec2-terraform/modules/cluster"

  cluster_name = local.cluster_name
}

module "instance_profile" {
  source = "github.com/alexandresperon/aws-ecs-ec2-terraform/modules/instance_profile"

  name = "${local.cluster_name}-${local.instance_group}-instance-profile-${local.environment}"
}

module "ecs_instance" {
  source = "github.com/alexandresperon/aws-ecs-ec2-terraform/modules/ecs_instance"

  environment        = local.environment
  cluster            = local.cluster_name
  alb_security_group = module.alb.alb_security_group_id
  instance_group     = local.instance_group
  vpc_id             = local.vpc_id
  instance_type      = "t2.micro"
  instance_profile   = module.instance_profile.iam_instance_profile_id
  cloudwatch_prefix  = local.instance_group
}

module "ecs_service" {
  source = "github.com/alexandresperon/aws-ecs-ec2-terraform/modules/ecs_service"

  aws_region     = local.aws_region
  environment    = local.environment
  service_name   = "keycloak-service"
  container_name = "keycloak"
  image          = "quay.io/keycloak/keycloak:latest"
  entry_point    = ["/opt/keycloak/bin/kc.sh", "start-dev"]
  environment_vars = [
    { "name" : "KC_DB", "value" : "mysql" },
    { "name" : "KC_DB_URL", "value" : "jdbc:mysql://db_url:3306/database" },
    { "name" : "KC_DB_USERNAME", "value" : "db_username" },
    { "name" : "KC_DB_PASSWORD", "value" : "db_password" },
    { "name" : "KEYCLOAK_ADMIN", "value" : "admin" },
    { "name" : "KEYCLOAK_ADMIN_PASSWORD", "value" : "admin@123" },
    { "name" : "KC_HOSTNAME_STRICT", "value" : "false" }
  ]
  cluster              = module.cluster.aws_ecs_cluster_id
  vpc_id               = local.vpc_id
  launch_configuration = module.ecs_instance.launch_configuration_id
  cloudwatch_prefix    = local.environment
  load_balancer        = module.alb.alb_id
  container_port       = 8080
  asg_subnets          = local.subnets
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
}