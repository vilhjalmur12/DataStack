resource "hcloud_server" "mysql" {
  name        = "mysql-server"
  image       = "ubuntu-22.04"
  server_type = var.mysql_instance_type
  location    = var.mysql_location
  ssh_keys    = ["default"]
  user_data   = file("init-mysql.sh")
}