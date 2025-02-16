output "priv_sub_az" {
  value       = aws_subnet.private_subnet.availability_zone
  description = "Private Subnet's AZ"
}

output "pub_sub_az" {
  value       = aws_subnet.public_subnet.availability_zone
  description = "Public Subnet's AZ"
}

output "app_host_ip" {
  value = aws_instance.app_host.private_ip
}

output "bastion_host_private_ip" {
  value = aws_instance.bastion_host.private_ip
}

output "bastion_host_public_ip" {
  value = aws_eip.bastion_eip.public_ip
}