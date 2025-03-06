resource "aws_iam_role" "terra_cw_role" {
  name = "CloudWatchAgentRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      "Action": [
                "sts:AssumeRole"
            ]
            
    }]
  })
}

# IAM Policy in Terraform
resource "aws_iam_policy_attachment" "terra_cw_attach" {
  name       = "cw-agent-policy-attach"
  roles      = [aws_iam_role.terra_cw_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "terra_cw_profile" {
  name = "CloudWatchAgentInstanceProfile"
  role = aws_iam_role.terra_cw_role.name
}