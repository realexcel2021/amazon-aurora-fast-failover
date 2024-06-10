module "AppDbProxy_rds_proxy" {
  source = "terraform-aws-modules/rds-proxy/aws"

  name                   = "app-db-proxy"
  iam_role_name          = "AppDbProxy-role"
  vpc_subnet_ids         = module.vpc.database_subnets
  vpc_security_group_ids = [module.AppProxySecurityGroup.security_group_id]

  endpoints = {
    read_write = {
      name                   = "read-write-endpoint"
      vpc_subnet_ids         = module.vpc.database_subnets
      vpc_security_group_ids = [module.AppProxySecurityGroup.security_group_id]
    },
    read_only = {
      name                   = "read-only-endpoint"
      vpc_subnet_ids         = module.vpc.database_subnets
      vpc_security_group_ids = [module.AppProxySecurityGroup.security_group_id]
      target_role            = "READ_ONLY"
    }
  }

  auth = {
    "root" = {
      description        = "Aurora PostgreSQL superuser password"
      secret_arn         = "${aws_secretsmanager_secret.db_pass.arn}:password"
    }
  }

  # Target Aurora cluster
  engine_family         = "POSTGRESQL"
  target_db_cluster     = true
  db_cluster_identifier = module.aurora_postgresql_v2_primary_app.cluster_id

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
}