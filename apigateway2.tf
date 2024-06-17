################################################
# API gateway from scratch
################################################

resource "aws_api_gateway_rest_api" "my_api" {
  name = "${random_pet.this.id}-rest"
  description = "rest api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#############################################
# api gateway resource (routes)
############################################

resource "aws_api_gateway_resource" "get-cluster-info" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "get-cluster-info"
}

resource "aws_api_gateway_resource" "get-failover-events" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "get-failover-events"
}

resource "aws_api_gateway_resource" "bypass-rds-proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "bypass-rds-proxy"
}

resource "aws_api_gateway_resource" "calculate-recovery-time" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "calculate-recovery-time"
}

resource "aws_api_gateway_resource" "generate-sample-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "generate-sample-traffic"
}

resource "aws_api_gateway_resource" "get-client-errors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "get-client-errors"
}

resource "aws_api_gateway_resource" "get-client-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "get-client-traffic"
}

resource "aws_api_gateway_resource" "perform-health-check" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "perform-health-check"
}

resource "aws_api_gateway_resource" "initiate-failover" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "initiate-failover"
}

resource "aws_api_gateway_resource" "reset-demo-environment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "reset-demo-environment"
}

resource "aws_api_gateway_resource" "update-database-nacl" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "update-database-nacl"
}

##############################################
# api gateway methods
##############################################

resource "aws_api_gateway_method" "get-cluster-info" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-cluster-info.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get-failover-events" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-failover-events.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "bypass-rds-proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.bypass-rds-proxy.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "calculate-recovery-time" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.calculate-recovery-time.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "generate-sample-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.generate-sample-traffic.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get-client-errors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-errors.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get-client-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-traffic.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "perform-health-check" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.perform-health-check.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "initiate-failover" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.initiate-failover.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "reset-demo-environment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.reset-demo-environment.id
  http_method = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_method" "update-database-nacl" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update-database-nacl.id
  http_method = "GET"
  authorization = "NONE"
}


##############################################
# api gateway integrations
##############################################

resource "aws_api_gateway_integration" "get-cluster-info" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-cluster-info.id
  http_method = aws_api_gateway_method.get-cluster-info.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.lambda_function.lambda_function_arn}/invocations"  
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn

  request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\"\\ #if($foreach.hasNext),#end #end }\n}"
  }

}

resource "aws_api_gateway_integration" "get-failover-events" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-failover-events.id
  http_method = aws_api_gateway_method.get-failover-events.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.GetFailoverEvents.lambda_function_arn}/invocations" 
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
  request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\"\\ #if($foreach.hasNext),#end #end }\n}"
  }
}
 
resource "aws_api_gateway_integration" "bypass-rds-proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.bypass-rds-proxy.id
  http_method = aws_api_gateway_method.bypass-rds-proxy.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.BypassRdsProxy.lambda_function_arn}/invocations"  
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\"\\ #if($foreach.hasNext),#end #end }\n}"
  }
}

resource "aws_api_gateway_integration" "calculate-recovery-time" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.calculate-recovery-time.id
  http_method = aws_api_gateway_method.calculate-recovery-time.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.CalculateRecoveryTime.lambda_function_arn}/invocations"   
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "generate-sample-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.generate-sample-traffic.id
  http_method = aws_api_gateway_method.generate-sample-traffic.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.GenerateSampleTraffic.lambda_function_arn}/invocations"  
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "get-client-errors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-errors.id
  http_method = aws_api_gateway_method.get-client-errors.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.GetClientErrors.lambda_function_arn}/invocations"  
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "get-client-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-traffic.id
  http_method = aws_api_gateway_method.get-client-traffic.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.GetClientTraffic.lambda_function_arn}/invocations"   
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "perform-health-check" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.perform-health-check.id
  http_method = aws_api_gateway_method.perform-health-check.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.HealthCheck.lambda_function_arn}/invocations"
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "initiate-failover" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.initiate-failover.id
  http_method = aws_api_gateway_method.initiate-failover.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.InitiateFailover.lambda_function_arn}/invocations" 
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "reset-demo-environment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.reset-demo-environment.id
  http_method = aws_api_gateway_method.reset-demo-environment.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.ResetDemoEnvironment.lambda_function_arn}/invocations"  
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}

resource "aws_api_gateway_integration" "update-database-nacl" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update-database-nacl.id
  http_method = aws_api_gateway_method.update-database-nacl.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  type = "AWS"
  uri = "arn:aws:apigateway:${local.region1}:lambda:path/2015-03-31/functions/${module.UpdateDatabaseNacl.lambda_function_arn}/invocations"  
  credentials = module.apigateway_put_events_to_lambda_us_east_1.iam_role_arn
    request_templates = {
    "application/json" = "#set($params = $input.params())\n{\n\"queryParams\": { #set($paramSet = $params.get('querystring')) #foreach($paramName in $paramSet.keySet()) \"$paramName\" : \"$util.escapeJavaScript($paramSet.get($paramName))\" #if($foreach.hasNext),#end #end } \n}"
  }
}


##############################################
# api gateway response
##############################################

resource "aws_api_gateway_method_response" "get-cluster-info" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-cluster-info.id
  http_method = aws_api_gateway_method.get-cluster-info.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "get-failover-events" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-failover-events.id
  http_method = aws_api_gateway_method.get-failover-events.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "bypass-rds-proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.bypass-rds-proxy.id
  http_method = aws_api_gateway_method.bypass-rds-proxy.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "calculate-recovery-time" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.calculate-recovery-time.id
  http_method = aws_api_gateway_method.calculate-recovery-time.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "generate-sample-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.generate-sample-traffic.id
  http_method = aws_api_gateway_method.generate-sample-traffic.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "get-client-errors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-errors.id
  http_method = aws_api_gateway_method.get-client-errors.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "get-client-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-traffic.id
  http_method = aws_api_gateway_method.get-client-traffic.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "perform-health-check" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.perform-health-check.id
  http_method = aws_api_gateway_method.perform-health-check.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "initiate-failover" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.initiate-failover.id
  http_method = aws_api_gateway_method.initiate-failover.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "reset-demo-environment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.reset-demo-environment.id
  http_method = aws_api_gateway_method.reset-demo-environment.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}

resource "aws_api_gateway_method_response" "update-database-nacl" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update-database-nacl.id
  http_method = aws_api_gateway_method.update-database-nacl.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true

  }
}


############################################
# integration response
############################################

resource "aws_api_gateway_integration_response" "get-cluster-info" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-cluster-info.id
  http_method = aws_api_gateway_method.get-cluster-info.http_method
  status_code = aws_api_gateway_method_response.get-cluster-info.status_code

  depends_on = [
    aws_api_gateway_method.get-cluster-info,
    aws_api_gateway_integration.get-cluster-info
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "get-failover-events" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-failover-events.id
  http_method = aws_api_gateway_method.get-failover-events.http_method
  status_code = aws_api_gateway_method_response.get-failover-events.status_code

  depends_on = [
    aws_api_gateway_method.get-failover-events,
    aws_api_gateway_integration.get-failover-events
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "bypass-rds-proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.bypass-rds-proxy.id
  http_method = aws_api_gateway_method.bypass-rds-proxy.http_method
  status_code = aws_api_gateway_method_response.bypass-rds-proxy.status_code

  depends_on = [
    aws_api_gateway_method.bypass-rds-proxy,
    aws_api_gateway_integration.bypass-rds-proxy
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "calculate-recovery-time" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.calculate-recovery-time.id
  http_method = aws_api_gateway_method.calculate-recovery-time.http_method
  status_code = aws_api_gateway_method_response.calculate-recovery-time.status_code

  depends_on = [
    aws_api_gateway_method.calculate-recovery-time,
    aws_api_gateway_integration.calculate-recovery-time
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "generate-sample-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.generate-sample-traffic.id
  http_method = aws_api_gateway_method.generate-sample-traffic.http_method
  status_code = aws_api_gateway_method_response.generate-sample-traffic.status_code

  depends_on = [
    aws_api_gateway_method.generate-sample-traffic,
    aws_api_gateway_integration.generate-sample-traffic
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "get-client-errors" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-errors.id
  http_method = aws_api_gateway_method.get-client-errors.http_method
  status_code = aws_api_gateway_method_response.get-client-errors.status_code

  depends_on = [
    aws_api_gateway_method.get-client-errors,
    aws_api_gateway_integration.get-client-errors
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "get-client-traffic" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.get-client-traffic.id
  http_method = aws_api_gateway_method.get-client-traffic.http_method
  status_code = aws_api_gateway_method_response.get-client-traffic.status_code

  depends_on = [
    aws_api_gateway_method.get-client-traffic,
    aws_api_gateway_integration.get-client-traffic
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "perform-health-check" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.perform-health-check.id
  http_method = aws_api_gateway_method.perform-health-check.http_method
  status_code = aws_api_gateway_method_response.perform-health-check.status_code

  depends_on = [
    aws_api_gateway_method.perform-health-check,
    aws_api_gateway_integration.perform-health-check
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "initiate-failover" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.initiate-failover.id
  http_method = aws_api_gateway_method.initiate-failover.http_method
  status_code = aws_api_gateway_method_response.initiate-failover.status_code

  depends_on = [
    aws_api_gateway_method.initiate-failover,
    aws_api_gateway_integration.initiate-failover
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "reset-demo-environment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.reset-demo-environment.id
  http_method = aws_api_gateway_method.reset-demo-environment.http_method
  status_code = aws_api_gateway_method_response.reset-demo-environment.status_code

  depends_on = [
    aws_api_gateway_method.reset-demo-environment,
    aws_api_gateway_integration.reset-demo-environment
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

resource "aws_api_gateway_integration_response" "update-database-nacl" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update-database-nacl.id
  http_method = aws_api_gateway_method.update-database-nacl.http_method
  status_code = aws_api_gateway_method_response.update-database-nacl.status_code

  depends_on = [
    aws_api_gateway_method.update-database-nacl,
    aws_api_gateway_integration.update-database-nacl
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "$input.path('$.body')"
  }
}

###########################################
# api gateway deployment
###########################################

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.get-cluster-info,
    aws_api_gateway_integration.get-cluster-info, # Add this line
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = "default"
}

resource "aws_api_gateway_domain_name" "this" {
  certificate_arn = aws_acm_certificate_validation.api.certificate_arn
  domain_name     = "api.${var.domainName}"
  
}


resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.my_api.id
  stage_name  = "default"
  domain_name = aws_api_gateway_domain_name.this.domain_name

  depends_on = [ aws_api_gateway_deployment.deployment ]
}