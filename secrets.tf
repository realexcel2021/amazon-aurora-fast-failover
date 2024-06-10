resource "random_string" "this" {
  length = 5
  special = false
}

resource "aws_secretsmanager_secret" "db_pass" {
  name = "aurora-serverless/postgresql/${random_string.this.result}"

  replica {
    region = local.region2
  }

}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.db_pass.id
  secret_string = <<EOF
    {
        "password": "${random_password.master.result}",
        "username": "root",
        "database" : "template1"
    }
  EOF
}