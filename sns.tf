
resource "aws_sns_topic" "product_topic_notification" {
  name = "product_topic_notification"
}

resource "aws_sns_topic_subscription" "target" {
  topic_arn = aws_sns_topic.product_topic_notification.arn
  protocol  = "email"
  endpoint  = "ayoub.mouak.2015@gmail.com"
}