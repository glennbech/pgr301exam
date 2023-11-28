resource "aws_sns_topic" "alarm_topic" {
  name = "alarm-topic"
}

resource "aws_sns_topic_subscription" "alarm_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "violation_alarm" {
  alarm_name          = "TrueViolationCountAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "violations.true.count"
  namespace           = "candidate-2029-apprunner"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when the number of true violations is 1 or more"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
}
