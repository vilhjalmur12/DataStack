resource "hcloud_server" "postgres" {
  name        = "postgres-server"
  image       = "ubuntu-22.04"
  server_type = var.postgres_instance_type
  location    = var.postgres_location
  ssh_keys    = ["default"]
  user_data   = file("init-postgres.sh")
}

resource "hcloud_volume" "postgres_data" {
  name      = "postgres-data-volume"
  size      = var.postgres_volume_size
  location  = var.postgres_location
  server_id = hcloud_server.postgres.id
  format    = "ext4"
  automount = true
}