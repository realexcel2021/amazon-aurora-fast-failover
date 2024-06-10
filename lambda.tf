module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "GetClusterInfo"
  description   = "Retrieves DB cluster info"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128  

  source_path = "${path.module}/src/GetClusterInfo"

  environment_variables = {
    REGIONAL_APP_DB_CLUSTER_IDENTIFIER = module.aurora_postgresql_v2_secondary.cluster_id
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     rds = {
       effect    = "Allow",
       actions   = ["rds:DescribeDBClusters", "rds:DescribeDBInstances"],
       resources = ["*"]
     }
   }
}

module "GetFailoverEvents" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "GetFailoverEvents"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/GetFailoverEvents"

  environment_variables = {
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    REGIONAL_DEMO_DB_SECRET_ARN    = "${aws_secretsmanager_secret.db_pass.arn}"
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
   }
}


module "BypassRdsProxy" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "BypassRdsProxy"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/BypassRdsProxy"

  environment_variables = {
    GLOBAL_APP_DB_READER_ENDPOINT = local.reader_endpoint_app
    GLOBAL_APP_DB_WRITER_ENDPOINT = local.writer_endpoint_app
    PRIVATE_HOSTED_ZONE_ID        = var.zone_id
    REGIONAL_APP_DB_CLUSTER_READER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_reader_endpoint
    REGIONAL_APP_DB_CLUSTER_WRITER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_endpoint
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt", "route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
   }
}

module "CalculateRecoveryTime" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "CalculateRecoveryTime"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/CalculateRecoveryTime"

  environment_variables = {
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    REGIONAL_DEMO_DB_SECRET_ARN    = "${aws_secretsmanager_secret.db_pass.arn}"

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt", "route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
   }
}

module "GenerateSampleTraffic" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "GenerateSampleTraffic"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/GenerateSampleTraffic"

  environment_variables = {
    TEST_TRAFFIC_TOPIC_ARN = "${aws_sns_topic.test-traffic.arn}"
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["sns:Publish", "kms:Decrypt"],
       resources = ["*"]
     }
   }
}

module "GetClientErrors" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "GetClientErrors"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/GetClientErrors"

  environment_variables = {
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    REGIONAL_DEMO_DB_SECRET_ARN    = "${aws_secretsmanager_secret.db_pass.arn}"
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     rds = {
       effect    = "Allow",
       actions   = ["rds:DescribeDBClusters"],
       resources = ["*"]
     }
   }
}

module "GetClientTraffic" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "GetClientTraffic"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/GetClientTraffic"

  environment_variables = {
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    REGIONAL_DEMO_DB_SECRET_ARN    = "${aws_secretsmanager_secret.db_pass.arn}"

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
   }
}

module "HealthCheck" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "HealthCheck"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/HealthCheck"

  environment_variables = {
    REGIONAL_APP_DB_CLUSTER_IDENTIFIER = module.aurora_postgresql_v2_secondary.cluster_id
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     rds = {
       effect    = "Allow",
       actions   = ["rds:DescribeDBClusters"],
       resources = ["*"]
     }
   }
}

module "InitiateFailover" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "InitiateFailover"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/InitiateFailover"

  environment_variables = {
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    REGIONAL_APP_DB_CLUSTER_IDENTIFIER = module.aurora_postgresql_v2_secondary.cluster_id
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     rds = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt", "rds:FailoverDBCluster"],
       resources = ["*"]
     }
   }
}

module "ResetDemoEnvironment" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "ResetDemoEnvironment"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/ResetDemoEnvironment"

  environment_variables = {
    DATABASE_CANARY_CRON_NAME = "database-canary"
    FAILOVER_REGION_NAME      = local.region2
    GLOBAL_APP_DB_READER_ENDPOINT = local.reader_endpoint_app
    GLOBAL_APP_DB_WRITER_ENDPOINT = local.writer_endpoint_app
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    PRIVATE_HOSTED_ZONE_ID  = var.zone_id
    PROXY_MONITOR_CRON_NAME = "RdsProxyMonitorCron"
    PUBLIC_FQDN = "ha-serverless.devopslord.com"
    PUBLIC_HOSTED_ZONE_ID = var.zone_id
    REGIONAL_APP_DB_CLUSTER_READER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_reader_endpoint
    REGIONAL_APP_DB_CLUSTER_WRITER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_endpoint
    REGIONAL_APP_DB_NACL_ID = "${aws_network_acl.DatabaseAcl.id}"
    REGIONAL_APP_DB_PROXY_READER_ENDPOINT = module.AppDbProxy_rds_proxy.proxy_endpoint
    REGIONAL_APP_DB_PROXY_WRITER_ENDPOINT = module.AppDbProxy_rds_proxy.proxy_endpoint
    REGIONAL_APP_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_WEB_ALB_FQDN = ""
    REGIONAL_WEB_ALB_HOSTED_ZONE_ID = ""
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt", "ec2:ReplaceNetworkAclEntry", "events:EnableRule", "events:DisableRule", "route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
   }
}

module "UpdateDatabaseNacl" {
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "UpdateDatabaseNacl"
  description   = "Retrieves failover events from the database"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/UpdateDatabaseNacl"

  environment_variables = {
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    REGIONAL_APP_DB_NACL_ID = "${aws_network_acl.DatabaseAcl.id}"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
     ec2 = {
      effect = "Allow"
      actions = ["ec2:ReplaceNetworkAclEntry"]
      resources = ["*"]
     }
   }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "./src/StackSet-multi-region-postgresql-aurora-layer.zip"
  layer_name = "amazon-aurora-failover-layer"

  compatible_runtimes = ["python3.11", "python3.9", "python3.10"]
}


###########################################
# Cron jobs
###########################################

module "ClientEmulator" { # the SNS guy here
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "ClientEmulator"
  description   = "Emulates legitimate client traffic"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/ClientEmulator"

  environment_variables = {
    FAILOVER_REGION_NAME = local.region2
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    PRIMARY_REGION_NAME = local.region1
    PUBLIC_FQDN = "ha-serverless.devopslord.com"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
   }
}

module "DatabaseCanary" { # the event bridge cron job guy here
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "DatabaseCanary"
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/DatabaseCanary"

  environment_variables = {
    DATABASE_CANARY_CRON_NAME = "database-canary"
    GLOBAL_APP_DB_CLUSTER_IDENTIFIER = ""
    GLOBAL_APP_DB_WRITER_ENDPOINT = local.writer_endpoint_app
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    PUBLIC_FQDN = "ha-serverless.devopslord.com"
    REGIONAL_APP_DB_CLUSTER_ARN = ""
    REGIONAL_APP_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
     rds = {
       effect    = "Allow",
       actions   = ["rds:DescribeGlobalClusters", "rds:RemoveFromGlobalCluster"],
       resources = ["*"]
     }
     eventbridge = {
       effect    = "Allow",
       actions   = ["events:*"],
       resources = ["*"]
     }
   }
}


module "FailoverCompletedHandler" { # the rds event bridge guy here
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "FailoverCompletedHandler"
  description   = "Invokes Handler When Failover is Completed"  
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/FailoverCompletedHandler"

  environment_variables = {
    FAILOVER_REGION_NAME = local.region2
    GLOBAL_APP_DB_READER_ENDPOINT = local.reader_endpoint_app
    GLOBAL_APP_DB_WRITER_ENDPOINT = local.writer_endpoint_app
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    PRIMARY_REGION_NAME = local.region1
    PRIVATE_HOSTED_ZONE_ID = var.zone_id
    PROXY_MONITOR_CRON_NAME = "RdsProxyMonitorCron"
    PUBLIC_FQDN = "ha-serverless.devopslord.com"
    PUBLIC_HOSTED_ZONE_ID = var.zone_id
    REGIONAL_APP_DB_CLUSTER_IDENTIFIER = module.aurora_postgresql_v2_secondary.cluster_id
    REGIONAL_APP_DB_CLUSTER_READER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_reader_endpoint
    REGIONAL_APP_DB_CLUSTER_WRITER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_endpoint
    REGIONAL_APP_DB_PROXY_NAME = "app-db-proxy"
    REGIONAL_APP_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_WEB_ALB_FQDN = ""
    REGIONAL_WEB_ALB_HOSTED_ZONE_ID = ""

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
     rds = {
       effect    = "Allow",
       actions   = ["rds:RegisterDBProxyTargets"],
       resources = ["*"]
     }
     route53 = {
       effect    = "Allow",
       actions   = ["route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
   }
}

module "FailoverStartedHandler" { # another event bridge guy here
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "FailoverStartedHandler"
  description   = "Invokes Handler When Failover is Completed"  
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/FailoverStartedHandler"

  environment_variables = {
    FAILOVER_REGION_NAME = local.region2
    GLOBAL_APP_DB_READER_ENDPOINT = local.reader_endpoint_app
    GLOBAL_APP_DB_WRITER_ENDPOINT = local.writer_endpoint_app
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    GLOBAL_DEMO_DB_READER_ENDPOINT = local.reader_endpoint
    PRIMARY_REGION_NAME = local.region1
    PRIVATE_HOSTED_ZONE_ID = var.zone_id
    PROXY_MONITOR_CRON_NAME = "RdsProxyMonitorCron"
    PUBLIC_FQDN = "ha-serverless.devopslord.com"
    PUBLIC_HOSTED_ZONE_ID = var.zone_id
    REGIONAL_APP_DB_CLUSTER_IDENTIFIER = module.aurora_postgresql_v2_secondary.cluster_id
    REGIONAL_APP_DB_CLUSTER_READER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_reader_endpoint
    REGIONAL_APP_DB_CLUSTER_WRITER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_endpoint
    REGIONAL_APP_DB_PROXY_NAME = "app-db-proxy"
    REGIONAL_APP_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_WEB_ALB_FQDN = ""
    REGIONAL_WEB_ALB_HOSTED_ZONE_ID = ""

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
     rds = {
       effect    = "Allow",
       actions   = ["rds:RegisterDBProxyTargets"],
       resources = ["*"]
     }
     route53 = {
       effect    = "Allow",
       actions   = ["route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
     eventbridge = {
       effect    = "Allow",
       actions   = ["events:EnableRule"],
       resources = ["*"]
     }
   }
}


module "RdsProxyMonitor" { # another event bridge cron
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "RdsProxyMonitor"
  description   = "Invokes Handler When Failover is Completed"  
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/RdsProxyMonitor"

  environment_variables = {
    FAILOVER_REGION_NAME = local.region2
    GLOBAL_APP_DB_READER_ENDPOINT = local.reader_endpoint_app
    GLOBAL_APP_DB_WRITER_ENDPOINT = local.writer_endpoint_app
    GLOBAL_DEMO_DB_WRITER_ENDPOINT = local.writer_endpoint
    GLOBAL_DEMO_DB_READER_ENDPOINT = local.reader_endpoint
    PRIMARY_REGION_NAME = local.region1
    PRIVATE_HOSTED_ZONE_ID = var.zone_id
    PROXY_MONITOR_CRON_NAME = "RdsProxyMonitorCron"
    PUBLIC_FQDN = "ha-serverless.devopslord.com"
    PUBLIC_HOSTED_ZONE_ID = var.zone_id
    REGIONAL_APP_DB_CLUSTER_IDENTIFIER = module.aurora_postgresql_v2_secondary.cluster_id
    REGIONAL_APP_DB_CLUSTER_READER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_reader_endpoint
    REGIONAL_APP_DB_CLUSTER_WRITER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_endpoint
    REGIONAL_APP_DB_PROXY_NAME = "app-db-proxy"
    REGIONAL_APP_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_DEMO_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"
    REGIONAL_WEB_ALB_FQDN = ""
    REGIONAL_WEB_ALB_HOSTED_ZONE_ID = ""

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
     rds = {
       effect    = "Allow",
       actions   = ["rds:RegisterDBProxyTargets"],
       resources = ["*"]
     }
     route53 = {
       effect    = "Allow",
       actions   = ["route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
   }
}

module "Website" { # loadbalancer guy here!
  source = "terraform-aws-modules/lambda/aws"
  layer_name = aws_lambda_layer_version.lambda_layer.layer_name


  function_name = "Website"
  description   = "Serves as the root handler behind the Web ALB"  
  handler       = "index.handler"
  runtime       = "python3.11"
  architectures = ["x86_64"]
  timeout       = 60
  tracing_mode  = "PassThrough"
  publish       = true
  store_on_s3   = false
  memory_size   = 128

  source_path = "${path.module}/src/Website"

  environment_variables = {
    REGIONAL_APP_DB_CLUSTER_WRITER_ENDPOINT = module.aurora_postgresql_v2_primary.cluster_endpoint
    REGIONAL_APP_DB_SECRET_ARN = "${aws_secretsmanager_secret.db_pass.arn}"

  }

  vpc_subnet_ids = module.vpc.private_subnets
  vpc_security_group_ids = [module.LambdaSecurityGroup.security_group_id]

   attach_policies    = true
   policies           = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
   number_of_policies = 2

   attach_policy_statements = true
   policy_statements = {
     secretsmanager = {
       effect    = "Allow",
       actions   = ["secretsmanager:GetSecretValue", "kms:Decrypt"],
       resources = ["*"]
     }
     rds = {
       effect    = "Allow",
       actions   = ["rds:RegisterDBProxyTargets"],
       resources = ["*"]
     }
     route53 = {
       effect    = "Allow",
       actions   = ["route53:ChangeResourceRecordSets"],
       resources = ["*"]
     }
   }
}