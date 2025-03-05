output "cloudwatch_alarm" {
  value = aws_cloudwatch_metric_alarm.cpu_high.id
}
