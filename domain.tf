
######
# ACM
######

data "aws_route53_zone" "this" {
  zone_id = var.zone_id
  private_zone = false
}



# ##########
# # Route53
# ##########


resource "aws_acm_certificate" "api" {
  domain_name       = "api.${var.domainName}"
  validation_method = "DNS"
  subject_alternative_names = ["api.${var.domainName}"]
}


module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "${var.domainName}"
  zone_id     = data.aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn #module.acm.acm_certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]
}


resource "aws_route53_record" "api-region1" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "api.${var.domainName}"
  type    = "A"
  #ttl     = 60
  #health_check_id = aws_route53_health_check.region1.id
  #records = [ "${aws_api_gateway_rest_api.my_api.id}.execute-api.${local.region1}.amazonaws.com",  ]
  #set_identifier = "us-east-1_record"

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.this.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.this.cloudfront_zone_id
  }

  # weighted_routing_policy {
  #   weight = 10
  # }
}

resource "aws_route53_record" "lb-record" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${var.domainName}"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}


###########################################################
# database endpoints records
############################################################

resource "aws_route53_zone" "private" {
  name = "ha-serverless.devopslord.com.internal"

  vpc {
    vpc_id = module.vpc.vpc_id
    vpc_region = local.region1
  }

  vpc {
    vpc_id = module.vpc_secondary.vpc_id
    vpc_region = local.region2
  }
}

resource "aws_route53_record" "writer_endpoint_failover" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "demo.db.cluster.writer.ha-serverless.devopslord.com.internal"
  type    = "CNAME"
  ttl     = 60
  #health_check_id = aws_route53_health_check.region2.id
  records = [ module.aurora_postgresql_v2_secondary.cluster_endpoint ]
  set_identifier = "${local.region2}-db-record"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "writer_endpoint_main" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "demo.db.writer.ha-serverless.devopslord.com.internal"
  type    = "CNAME"
  ttl     = 60
  #health_check_id = aws_route53_health_check.region2.id
  records = [ module.aurora_postgresql_v2_primary.cluster_endpoint ]
  set_identifier = "us-east-1-db-record"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "read_endpoint_main" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "demo.db.cluster.reader.ha-serverless.devopslord.com.internal"
  type    = "CNAME"
  ttl     = 60
  #health_check_id = aws_route53_health_check.region2.id
  records = [ module.aurora_postgresql_v2_primary.cluster_reader_endpoint ]
  set_identifier = "us-east-1-db-record-read"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "read_endpoint_replica" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "demo.db.reader.ha-serverless.devopslord.com.internal"
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_secondary.cluster_reader_endpoint ]
  set_identifier = "us-west-1-db-record-read"
  
 weighted_routing_policy {
    weight = 90
  }
}


resource "aws_route53_record" "read_endpoint_replica_app" {
  zone_id = aws_route53_zone.private.zone_id
  name    = local.reader_endpoint_app
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_primary_app.cluster_reader_endpoint ]
  set_identifier = "us-east-1-db-record-read-app"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "writer_endpoint_replica_app" {
  zone_id = aws_route53_zone.private.zone_id
  name    = local.writer_endpoint_cluster_app
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_primary_app.cluster_endpoint ]
  set_identifier = "us-east-1-db-record-write-app"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "reader_endpoint_replica_app" {
  zone_id = aws_route53_zone.private.zone_id
  name    = local.reader_endpoint_cluster_app
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_primary_app.cluster_endpoint ]
  set_identifier = "us-east-1-db-record-read-cluster-app"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "writer_endpoint_replica_app_proxy" {
  zone_id = aws_route53_zone.private.zone_id
  name    = local.writer_endpoint_app # supposed to be proxy endpoint will add later
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_primary_app.cluster_endpoint ]
  set_identifier = "us-east-1-db-record-write-app-proxy"
  
 weighted_routing_policy {
    weight = 90
  }
}
