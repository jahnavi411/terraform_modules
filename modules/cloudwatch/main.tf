resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 120
  statistic          = "Average"
  threshold          = 80
  actions_enabled    = true
  alarm_actions      = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = var.asg_name
}