variable "namespace" {
  type = string
}

resource "aws_cloudwatch_metric_alarm" "violation_alarm" {
  alarm_name          = "TrueViolationCountAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "violations.true.count"
  namespace           = var.namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when the number of true violations is 1 or more"
  actions_enabled     = false

}
