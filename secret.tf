/*resource "aws_ssm_parameter" "app_host_ubuntu-key" {
  name        = "app_host_private-key"
  description = "Private SSH key for the App Host private EC2 instance"
  type        = "SecureString"
  value       = file("${aws_instance.app_host.private_ip}/home/ubuntu/.ssh/ssh-key")
}

data "aws_ssm_parameter" "app_host_ubuntu-key" {
  name            = aws_ssm_parameter.app_host_ubuntu-key.name
  with_decryption = true
}

output "app_host_ubuntu-key" {
  value = data.aws_ssm_parameter.app_host_ubuntu-key.id
  sensitive = true
}
*/