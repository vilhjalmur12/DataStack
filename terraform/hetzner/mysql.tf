resource "hcloud_server" "mysql" {
  name        = "mysql-db"
  image       = "ubuntu-22.04"
  server_type = "cpx21"  # 4 vCPUs, 8GB RAM
  location    = var.region
  ssh_keys    = [hcloud_ssh_key.default.name]
  firewall_ids = [hcloud_firewall.mysql.id]

  labels = {
    role  = "mysql"
    group = "bigdata-core"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "MYSQL_HOST=mysql-db" >> /etc/environment
  EOF
}
