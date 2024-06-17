
# module "api_gateway" {
#   source  = "terraform-aws-modules/apigateway-v2/aws"
#   version = "~> 0"

#   create_api_gateway = false

#   depends_on = [ aws_acm_certificate_validation.api ]

#   name          = "${random_pet.this.id}-http"
#   description   = "${random_pet.this.id} HTP api for us-east-1"
#   protocol_type = "HTTP"
#   create_default_stage = true

#   create_api_domain_name = true
  
#   domain_name_certificate_arn = aws_acm_certificate.api.arn # module.acm.acm_certificate_arn
#   domain_name = "api.${var.domainName}"

#   cors_configuration = {
#     allow_headers = ["*"]
#     allow_methods = ["*"]
#     allow_origins = ["*"]
#   }

#   integrations = {
#     "GET /get-cluster-info" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.lambda_function.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /get-failover-events" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.GetFailoverEvents.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /bypass-rds-proxy" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.BypassRdsProxy.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /calculate-recovery-time" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.CalculateRecoveryTime.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /generate-sample-traffic" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.GenerateSampleTraffic.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     } 

#     "GET /get-client-errors" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.GetClientErrors.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }   

#     "GET /get-client-traffic" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.GetClientTraffic.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /perform-health-check" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.HealthCheck.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /initiate-failover" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.InitiateFailover.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /reset-demo-environment" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.ResetDemoEnvironment.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#     "GET /update-database-nacl" = {
#       integration_type        = "AWS_PROXY"
#       authorizer_type         = "NONE"
#       lambda_arn              = module.UpdateDatabaseNacl.lambda_function_arn
#       integration_http_method = "POST"
#       passthrough_behavior    = "WHEN_NO_TEMPLATES"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#       credentials_arn     = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
#     }

#   }

# }



# module "api_gateway_us_east_2" {
#   source  = "terraform-aws-modules/apigateway-v2/aws"
#   version = "~> 0"

#   providers = {
#     aws = aws.region2
#   }

#   name          = "${random_pet.this.id}-http"
#   description   = "${random_pet.this.id} HTP api for region2"
#   protocol_type = "HTTP"

#   create_api_domain_name = true
#   domain_name_certificate_arn = aws_acm_certificate.api-region-2.arn # module.acm.acm_certificate_arn
#   domain_name = "api.${var.domainName}"


# }

