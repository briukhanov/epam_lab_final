output "web_server_address" {
  value = aws_instance.web_instance.public_dns
}
output "web_server_private_address" {
  value = aws_instance.web_instance.private_dns
}
output "docker_server_address" {
  value = aws_instance.docker_instance.public_dns
}
