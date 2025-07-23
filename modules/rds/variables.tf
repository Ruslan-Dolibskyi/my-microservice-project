variable "name" {
  description = "Унікальне ім’я бази або кластера"
  type        = string
}

variable "use_aurora" {
  description = "Якщо true — створюємо Aurora Cluster, інакше — просту RDS"
  type        = bool
  default     = false
}

# --- спільні ---
variable "engine" {
  description = "Тип бази (postgres, mysql)"
  type        = string
}
variable "engine_version" {
  description = "Версія движка для RDS"
  type        = string
}
variable "engine_cluster" {
  description = "Тип движка для Aurora (aurora-postgresql, aurora-mysql)"
  type        = string
}
variable "engine_version_cluster" {
  description = "Версія движка для Aurora"
  type        = string
}

variable "instance_class" {
  description = "Клас інстансу (db.t3.micro, db.t3.medium тощо)"
  type        = string
}
variable "allocated_storage" {
  description = "Обсяг сховища (ГБ) для звичайної RDS"
  type        = number
  default     = 20
}

variable "db_name" { type = string }
variable "username" { type = string }
variable "password" {
  type      = string
  sensitive = true
}

variable "vpc_id"           { type = string }
variable "subnet_private_ids" { type = list(string) }
variable "subnet_public_ids"  { type = list(string) }
variable "publicly_accessible" { 
  type = bool   
  default = false 
  }
variable "multi_az"           {
  type = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "parameters" {
  description = "Map додаткових параметрів for parameter group"
  type        = map(string)
  default     = {}
}

variable "aurora_replica_count" {
  description = "Кількість read-only реплік для Aurora"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Теги, що ляжуть на всі ресурси"
  type        = map(string)
  default     = {}
}