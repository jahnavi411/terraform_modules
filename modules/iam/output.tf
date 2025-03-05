output "iam_role" {
  value = aws_iam_instance_profile.terra_cw_profile.name
}