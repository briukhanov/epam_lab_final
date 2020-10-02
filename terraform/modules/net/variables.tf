variable "vpc_cidr" {
  description = "vpc CIDR block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "tags" {
  description = "Tag prefix to set on the resources."
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.1.0.0/24"
}

variable "route_table_cidr" {
  description = "Rout table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "web_ports" {
  description = "Ingress ports"
  # type        = string
}
