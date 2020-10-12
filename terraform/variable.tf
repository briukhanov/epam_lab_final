# AWS Region Where Resources Will be Created
variable "aws_region" { default = "eu-central-1" }
variable "private_key_ec2" {}
variable "DH_USER" {}
variable "DH_PWD" {}
variable "GITHUB_TOKEN" {}
variable "GITHUB_USER" {}

# { default = "../aws.pem" }

# AWS ec2_instance type
variable "web_instance_type" { default = "t2.medium" }
variable "docker_instance_type" { default = "t2.micro" }

# Name of private key stored in AWS. Used to access to ec2_instance
variable "instance_access_private_key" { default = "wibob-Frankfurt-aws" }

# variable "env_name" {
#   default = ""
# }

variable "workspace_to_env_name_map" {
  description = "The environmet name map"
  type        = map
  default = {
    dev     = "dev"
    staging = "stage"
    prod    = "prod"
  }
}
