locals {
  reader_endpoint_cluster = "demo.db.cluster.reader.ha-serverless.devopslord.com.internal"
  writer_endpoint_cluster = "demo.db.cluster.writer.ha-serverless.devopslord.com.internal"

  writer_endpoint = "demo.db.writer.ha-serverless.devopslord.com.internal"
  reader_endpoint = "demo.db.reader.ha-serverless.devopslord.com.internal"
}

locals {
  writer_endpoint_cluster_app = "app.db.cluster.writer.ha-serverless.devopslord.com.internal"

  writer_endpoint_app = "app.db.writer.ha-serverless.devopslord.com.internal"
  reader_endpoint_app = "app.db.reader.ha-serverless.devopslord.com.internal"
}

######
# ACM
######

data "aws_route53_zone" "this" {
  name = local.domain_name
  private_zone = false
}



# ##########
# # Route53
# ##########


resource "aws_acm_certificate" "api" {
  domain_name       = "api.${local.subdomain}.${local.domain_name}"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "api-region-2" {
  domain_name       = "api.${local.subdomain}.${local.domain_name}"
  validation_method = "DNS"
  provider = aws.region2
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
  name    = "api.${local.subdomain}"
  type    = "CNAME"
  ttl     = 60
  health_check_id = aws_route53_health_check.region1.id
  records = [ module.api_gateway.apigatewayv2_domain_name_target_domain_name ]
  set_identifier = "us-west-1_record"
  
  latency_routing_policy {
    region = local.region1
  }

}

resource "aws_route53_record" "api-region2" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "api.${local.subdomain}"
  type    = "CNAME"
  ttl     = 60
  health_check_id = aws_route53_health_check.region2.id
  records = [ module.api_gateway_us_east_2.apigatewayv2_domain_name_target_domain_name ]
  set_identifier = "us-west-2_record"
  
  latency_routing_policy {
    region = local.region2
  }

}

#########################################
# health check region1
#########################################
resource "aws_route53_health_check" "region1" {
  fqdn              = module.api_gateway.apigatewayv2_domain_name_id
  port              = 443
  type              = "HTTPS"
  resource_path     = "/MutationEvent"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "health-check-region-1"
  }
}

#########################################
# health check region2
#########################################

resource "aws_route53_health_check" "region2" {
  fqdn              = module.api_gateway_us_east_2.apigatewayv2_domain_name_id
  port              = 443
  type              = "HTTPS"
  resource_path     = "/MutationEvent"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "health-check-region-2"
  }
}

###########################################################
# database endpoints records
############################################################

resource "aws_route53_record" "writer_endpoint_failover" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "demo.db.cluster.writer.ha-serverless.devopslord.com.internal"
  type    = "CNAME"
  ttl     = 60
  #health_check_id = aws_route53_health_check.region2.id
  records = [ module.aurora_postgresql_v2_secondary.cluster_endpoint ]
  set_identifier = "us-west-2-db-record"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "writer_endpoint_main" {
  zone_id = data.aws_route53_zone.this.zone_id
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
  zone_id = data.aws_route53_zone.this.zone_id
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
  zone_id = data.aws_route53_zone.this.zone_id
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
  zone_id = data.aws_route53_zone.this.zone_id
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
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.writer_endpoint_cluster_app
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_primary_app.cluster_endpoint ]
  set_identifier = "us-east-1-db-record-write-app"
  
 weighted_routing_policy {
    weight = 90
  }
}

resource "aws_route53_record" "writer_endpoint_replica_app_proxy" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.writer_endpoint_app # supposed to be proxy endpoint will add later
  type    = "CNAME"
  ttl     = 60
  records = [ module.aurora_postgresql_v2_primary_app.cluster_endpoint ]
  set_identifier = "us-east-1-db-record-write-app-proxy"
  
 weighted_routing_policy {
    weight = 90
  }
}
