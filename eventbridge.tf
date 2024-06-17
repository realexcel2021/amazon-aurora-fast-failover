########################
# event rules
########################

resource "aws_cloudwatch_event_rule" "rds" {
  name        = "event-rule-rds"
  description = "Invokes Handler When Failover is Completed"

  event_pattern = jsonencode({
    detail-type = [
      "RDS DB Cluster Event"
    ]
    detail = {
      SourceArn = [module.aurora_postgresql_v2_primary_app.cluster_arn]
      EventID = ["RDS-EVENT-0071"]
    }
    source = ["aws.rds"]
  })
}

resource "aws_cloudwatch_event_rule" "rds2" {
  name        = "event-rule-rds"
  description = "Invokes Handler When Failover is Started"

  event_pattern = jsonencode({
    detail-type = [
      "RDS DB Cluster Event"
    ]
    detail = {
      SourceArn = [module.aurora_postgresql_v2_primary_app.cluster_arn]
      EventID = ["RDS-EVENT-0073"]
    }
    source = ["aws.rds"]
  })
}

resource "aws_cloudwatch_event_target" "rds" {
  rule      = aws_cloudwatch_event_rule.rds.name
  target_id = "failover-completed"
  arn       = module.FailoverCompletedHandler.lambda_function_arn
}

resource "aws_cloudwatch_event_target" "rds2" {
  rule      = aws_cloudwatch_event_rule.rds2.name
  target_id = "failover-started"
  arn       = module.FailoverStartedHandler.lambda_function_arn
}