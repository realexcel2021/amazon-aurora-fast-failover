output "cross_region_failover_link" {
  value = "https://dashboard.${var.domainName}/cross-region-failover.html?apiHost=api.${var.domainName}&primaryRegion=${local.region1}&failoverRegion=${local.region2}"
}

output "in_region_failover_link" {
  value = "https://dashboard.${var.domainName}/in-region-failover.html?apiHost=api.${var.domainName}&primaryRegion=${local.region1}&failoverRegion=${local.region2}"
}