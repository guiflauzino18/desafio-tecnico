variable "pg_data" {
  type = string
  default = "/var/lib/postgresql/data"
}

variable "pg_user"{
    type = string
}

variable "pg_pass" {
  type = string
}

variable "pg_port" {
  type = number
  default = 5432
}

variable "pg_db_name" {
  type = string
  default = "users"
}

variable "backend_port" {
  type = number
  default = 3000
}