variable "ec2_images" {
  type = map
  default = {
    "us-east-1"      = "ami-06b263d6ceff0b3dd"
    "us-east-2"      = "ami-0010d386b82bc06f0"
    "us-west-1"      = "ami-0b33356b362c56df5"
    "us-west-2"      = "ami-0ba60995c1589da9d"
    "ap-south-1"     = "ami-063a57e81279c601b"
    "ap-northeast-2" = "ami-061b0ee20654981ab"
    "ap-southeast-1" = "ami-0b44582c8c5b24a49"
    "ap-southeast-2" = "ami-0c6cdb2e7cf34ada4"
    "ap-northeast-1" = "ami-08046c40513c3265e"
    "ca-central-1"   = "ami-0db10d1bd827c7426"
    "eu-central-1"   = "ami-0e63910157459607d"
    "eu-west-1"      = "ami-04137ed1a354f54c4"
    "eu-west-2"      = "ami-0287acb18b6d8efff"
    "eu-west-3"      = "ami-006987b5e26f0d62e"
    "eu-north-1"     = "ami-0e769fbef3dc1c3b8"
  }
}
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}
variable "web_instance_type" {
  description = ""
  type        = string
  default     = "10.1.0.0/24"
}
variable "docker_instance_type" {
  description = ""
  type        = string
  default     = "t2.micro"
}
variable "instance_access_private_key" {
  description = ""
  type        = string
}
variable "cluster_name" {
  description = ""
  type        = string
}
# variable "private_key_ec2" {
#   description = ""
#   type        = string
# }
variable "env_name" {
  description = ""
  type        = string
}
variable "sec_grp_id" {
  type        = string
  description = ""
}
variable "pub_subnet_id" {
  type        = string
  description = ""
}
variable "aws_ec2_key" {
  description = ""
}
