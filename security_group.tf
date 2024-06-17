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

  egress_with_cidr_blocks = [
    {
      protocol = "-1"
      from_port = 0
      to_port = 65535
      cidr_blocks = "0.0.0.0/0"
    }
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