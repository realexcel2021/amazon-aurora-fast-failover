module "LambdaSecurityGroup" {
  source = "terraform-aws-modules/security-group/aws"


  name        = "LambdaSecurityGroup"
  description = "Lambda Security Group"
  vpc_id      = module.vpc_secondary.vpc_id


  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = module.vpc_secondary.vpc_id
    },
  ]
}