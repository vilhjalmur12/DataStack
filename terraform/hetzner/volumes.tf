# Spark Volumes
resource "hcloud_volume" "spark_logs" {
  name       = "spark-logs"
  size       = 50
  location   = var.region
  format     = "ext4"
  server_ids = [hcloud_server.spark_master.id]
}

resource "hcloud_volume" "spark_data" {
  name       = "spark-data"
  size       = 100
  location   = var.region
  format     = "ext4"
  server_ids = [hcloud_server.spark_master.id]
}

# MySQL Volume
resource "hcloud_volume" "mysql_data" {
  name       = "mysql-data"
  size       = 50
  location   = var.region
  format     = "ext4"
  server_ids = [hcloud_server.mysql.id]
}

# PostgreSQL Volume
resource "hcloud_volume" "postgres_data" {
  name       = "postgres-data"
  size       = 50
  location   = var.region
  format     = "ext4"
  server_ids = [hcloud_server.postgres.id]
}

