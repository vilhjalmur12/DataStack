resource "hcloud_server" "postgres" {
  name        = "postgres-db"
  image       = "ubuntu-22.04"
  server_type = "cpx21"  # 4 vCPUs, 8GB RAM
  location    = var.region
  ssh_keys    = [hcloud_ssh_key.default.name]
  firewall_ids = [hcloud_firewall.postgres.id]

  labels = {
    role  = "postgres"
    group = "bigdata-core"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "POSTGRES_HOST=postgres-db" >> /etc/environment
  EOF
}
