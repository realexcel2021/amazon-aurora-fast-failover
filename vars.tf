variable "domainName" {
  type    = string
}

variable "zone_id" {
  type = string
}

locals {
  reader_endpoint_cluster = "demo.db.cluster.reader.${var.domainName}.internal"
  writer_endpoint_cluster = "demo.db.cluster.writer.${var.domainName}.internal"

  writer_endpoint = "demo.db.writer.${var.domainName}.internal"
  reader_endpoint = "demo.db.reader.${var.domainName}.internal"
}

locals {
  writer_endpoint_cluster_app = "app.db.cluster.writer.${var.domainName}.internal"
  reader_endpoint_cluster_app = "app.db.cluster.reader.${var.domainName}.internal"

  writer_endpoint_app = "app.db.writer.${var.domainName}.internal"
  reader_endpoint_app = "app.db.reader.${var.domainName}.internal"
}