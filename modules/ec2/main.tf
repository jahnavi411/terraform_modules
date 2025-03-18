resource "aws_launch_template" "terra_lt" {
  name_prefix = "terra-template"
  image_id = var.ami_id
  instance_type = var.instance_type
  user_data = filebase64("${path.module}/userdata.sh")
  network_interfaces {
    subnet_id = var.subnet_id  # Reference subnet from VPC module
     security_groups = [var.security_group]
  }
  iam_instance_profile {
    name = var.iam_role
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Terra Instance"
    }
  }
  depends_on = [var.vpc_id]
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [var.subnet_id]
  desired_capacity = 2
  max_size = 3
  min_size = 1
  health_check_type   = "EC2"
  health_check_grace_period = 300

  launch_template {
    version = "$Latest"
    id = aws_launch_template.terra_lt.id
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# for private key
resource "tls_private_key" "terra_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terra_keypair" {
  key_name   = "terra_key"       # Create "terra_key" to AWS!!
  public_key = tls_private_key.terra_private_key.public_key_openssh

  provisioner "local-exec" { # Create "terra_key.pem" to your computer!!
    command = "echo '${tls_private_key.terra_private_key.private_key_pem}' > ./terra_key.pem"
  }
}