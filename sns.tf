# create an sns topic
resource "aws_sns_topic" "user_updates" {
  name = "sns-topic"
}

# create an sns topic subscription
# terraform aws sns topic subscription
resource "aws_sns_topic_subscription" "notification_topic" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = "aminemastouri@gmail.com"
}

# NB:Remember to go to your email and confirm subscription