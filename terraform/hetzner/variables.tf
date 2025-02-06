variable "hcloud_token" {
  description = "API token for Hetzner Cloud"
  type        = string
  sensitive   = true
}

# PostgreSQL Variables
variable "postgres_instance_type" {
  description = "Hetzner instance type for PostgreSQL"
  type        = string
  default     = "cx41"
}

variable "postgres_location" {
  description = "Hetzner Cloud location for PostgreSQL"
  type        = string
  default     = "fsn1"
}

variable "postgres_volume_size" {
  description = "Size of the PostgreSQL storage volume"
  type        = number
  default     = 50
}

# MySQL Variables
variable "mysql_instance_type" {
  description = "Hetzner instance type for MySQL"
  type        = string
  default     = "cx31"
}

variable "mysql_location" {
  description = "Hetzner Cloud location for MySQL"
  type        = string
  default     = "nbg1"
}

variable "mysql_volume_size" {
  description = "Size of the MySQL storage volume"
  type        = number
  default     = 50
}