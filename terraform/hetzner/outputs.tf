output "mysql_ip" {
  value = hcloud_server.mysql.ipv4_address
}

output "postgres_ip" {
  value = hcloud_server.postgres.ipv4_address
}

output "postgres_volume_id" {
  value = hcloud_volume.postgres_data.id
}