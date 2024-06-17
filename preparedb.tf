# locals {
#   username = "root"
#   db_name = "postgres"
# }

# resource "null_resource" "db_setup" {
#   triggers = {
#     file = filesha1("./sql/demoprepare.sql")
#   }
#   provisioner "local-exec" {
#     command = "$env:PGPASSWORD=${random_password.master.result}; psql --host=${module.aurora_postgresql_v2_primary.cluster_endpoint} --port=5432 --username=${local.username} --dbname=postgres -a -f ./sql/demoprepare.sql"
#     interpreter = ["PowerShell", "-Command"]
#   }

#   depends_on = [ module.aurora_postgresql_v2_primary ]
# }

# resource "null_resource" "db_setup_app" {
#   triggers = {
#     file = filesha1("./sql/appprepare.sql")
#   }
#   provisioner "local-exec" {
#     command = "$env:PGPASSWORD=${random_password.master.result}; psql --host=${module.aurora_postgresql_v2_primary_app.cluster_endpoint} --port=5432 --username=${local.username}  --dbname=postgres -a -f ./sql/appprepare.sql"
#     interpreter = ["PowerShell", "-Command"]
#   }

#   depends_on = [ module.aurora_postgresql_v2_primary_app ]
# }