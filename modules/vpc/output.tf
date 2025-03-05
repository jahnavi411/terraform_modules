output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "vpc_id" {
  value = aws_vpc.terra_vpc.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}