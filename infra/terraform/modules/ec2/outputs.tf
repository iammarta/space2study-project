output "instance_id" {
  value = aws_instance.runtime.id
}

output "ec2_ami" {
  value = aws_instance.runtime.ami
}

output "ec2_type" {
  value = aws_instance.runtime.instance_type
}