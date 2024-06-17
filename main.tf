provider "aws" {
  region = local.region1

}

provider "aws" {
  region = local.region2
  alias  = "region2"

}

resource "random_pet" "this" {
  length = 2
}

locals {
  region1 = "us-east-1"
  region2 = "us-east-2"
  name  = "amazon-aurora-fast-failover"
  vpc_cidr = "10.0.0.0/16"
  azs                          = slice(data.aws_availability_zones.available.names, 0, 3)
  azs_secondary                = slice(data.aws_availability_zones.secondary.names, 0,2) 
  tags = {
    Project  = "Amazon-aurora-fast-failover"
  }

}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_availability_zones" "secondary" {
  provider = aws.region2
}