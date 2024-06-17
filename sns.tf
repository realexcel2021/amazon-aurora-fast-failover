resource "aws_sns_topic" "test-traffic" {
  name = "test-traffic-topic"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.test-traffic.arn
  protocol  = "lambda"
  endpoint  = module.ClientEmulator.lambda_function_arn
}