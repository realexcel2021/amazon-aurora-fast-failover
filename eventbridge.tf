########################
# cron job
########################

resource "aws_scheduler_schedule" "database-canary" {
  name       = "database-canary"
  group_name = "default"
  state      = "ENABLED" 

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(1 minute)"

  target {
    arn      = module.DatabaseCanary.lambda_function_arn
    role_arn = module.eventbridge_invoke_lambda.iam_role_arn
  
#   input = jsonencode({
#    MessageBody = "{\"key\":\"value\"}"
#   })
 
  }
}

resource "aws_scheduler_schedule" "RdsProxyMonitorCron" {
  name       = "RdsProxyMonitorCron"
  group_name = "default"
  state      = "ENABLED" 

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(1 minute)"

  target {
    arn      = module.RdsProxyMonitor.lambda_function_arn
    role_arn = module.eventbridge_invoke_lambda.iam_role_arn
  
#   input = jsonencode({
#    MessageBody = "{\"key\":\"value\"}"
#   })
 
  }
}