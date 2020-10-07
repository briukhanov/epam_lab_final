provider "aws" {
  region = var.aws_region
}
provider "github" {
  token = var.GITHUB_TOKEN
  owner = var.GITHUB_USER
}
# variable aws_ec2_key {}
# env_name = var.workspace_to_env_name_map[terraform.workspace]


# locals {
#   env_name = var.workspace_to_env_name_map[terraform.workspace]
# }


# ## get AZ's details
# data "aws_availability_zones" "availability_zones" {}


module "network" {
  source = "./modules/net"
  # vpc_cidr =
  tags = var.workspace_to_env_name_map[terraform.workspace]
  # public_subnet_cidr =
  # route_table_cidr =
  web_ports = ["22", "8080", "443"]
}

# resource "null_resource" "export_variable" {
#   provisioner "local-exec" {
#     command = "echo ${var.DH_USER} > vars.txt && echo ${var.DH_PWD} >> vars.txt && ${var.GITHUB_TOKEN} >> vars.txt && ${var.GITHUB_USER} >> vars.txt"
#   }
# }

module "app_layer" {
  source                      = "./modules/app"
  aws_region                  = var.aws_region
  web_instance_type           = var.web_instance_type
  docker_instance_type        = var.docker_instance_type
  instance_access_private_key = var.instance_access_private_key
  cluster_name                = "intermine"
  private_key_ec2             = var.private_key_ec2
  # aws_ec2_key   = var.aws_ec2_key
  env_name      = var.workspace_to_env_name_map[terraform.workspace]
  sec_grp_id    = module.network.sg_id
  pub_subnet_id = module.network.public_subnet_id
  docker_user   = var.DH_USER
  docker_pwd    = var.DH_PWD
}
