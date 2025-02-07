resource "hcloud_firewall" "spark" {
  name = "spark-firewall"
  rules = [
    {
      direction = "in"
      protocol  = "tcp"
      port      = "22"
      source_ips = ["0.0.0.0/0"]  # Allow SSH access
    },
    {
      direction = "in"
      protocol  = "tcp"
      port      = "7077"
      source_ips = ["0.0.0.0/0"]  # Allow Spark master communication
    },
    {
      direction = "in"
      protocol  = "tcp"
      port      = "8080"
      source_ips = ["0.0.0.0/0"]  # Allow Spark UI access
    }
  ]
}

resource "hcloud_firewall" "mysql" {
  name = "mysql-firewall"
  rules = [
    {
      direction = "in"
      protocol  = "tcp"
      port      = "22"
      source_ips = ["0.0.0.0/0"]  # Allow SSH access
    },
    {
      direction = "in"
      protocol  = "tcp"
      port      = "3306"
      source_ips = ["0.0.0.0/0"]  # Allow MySQL access
    }
  ]
}

resource "hcloud_firewall" "postgres" {
  name = "postgres-firewall"
  rules = [
    {
      direction = "in"
      protocol  = "tcp"
      port      = "22"
      source_ips = ["0.0.0.0/0"]  # Allow SSH access
    },
    {
      direction = "in"
      protocol  = "tcp"
      port      = "5432"
      source_ips = ["0.0.0.0/0"]  # Allow PostgreSQL access
    }
  ]
}

