resource "hcloud_server" "spark_master" {
  name        = "spark-master"
  image       = "ubuntu-22.04"
  server_type = var.spark_instance_type
  location    = var.region
  ssh_keys    = [hcloud_ssh_key.default.name]

  labels = {
    role  = "spark-master"
    group = "bigdata-query"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "SPARK_MASTER_HOST=spark-master" >> /etc/environment
  EOF
}

resource "hcloud_server" "spark_workers" {
  count       = var.spark_node_count
  name        = "spark-worker-${count.index}"
  image       = "ubuntu-22.04"
  server_type = var.spark_instance_type
  location    = var.region
  ssh_keys    = [hcloud_ssh_key.default.name]

  labels = {
    role  = "spark-worker"
    group = "bigdata-query"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "SPARK_MASTER_URL=spark://spark-master:7077" >> /etc/environment
  EOF
}
