output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.network.public_subnet_id
}

output "sg_id" {
  description = "Security Group ID"
  value       = module.network.sg_id
}

output "web_server_public_dns" {
  value = module.app_layer.web_server_address
}

output "web_server_private_dns" {
  value = module.app_layer.web_server_private_address
}

output "docker_server_public_dns" {
  value = module.app_layer.docker_server_address
}
