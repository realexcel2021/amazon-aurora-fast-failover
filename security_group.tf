module "LambdaSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "LambdaSecurityGroup"
  description = "Lambda Security Group"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}

module "AppProxySecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "AppProxySecurityGroup"
  description = "Lambda Security Group"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}