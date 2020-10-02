output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_security_group.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}
