variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"  # 기본값 설정 (선택사항)
}

variable "vpc_name" {
  description = "name of vpc"
  type        = string
  default     = "cwave"
}

variable "availability_zones" {
  description = "Map of AZ suffixes to full AZ names"
  type        = map(string)
  default = {
    a = "ap-northeast-2a"
    b = "ap-northeast-2b"
    c = "ap-northeast-2c"
  }
}

variable "public_subnet_cidrs" {
  description = "Map of public subnet CIDRs by AZ suffix"
  type        = map(string)
  default = {
    a = "10.1.1.0/24"
    b = "10.1.2.0/24"
    c = "10.1.3.0/24"
  }
}

variable "private_subnet_cidrs" {
  description = "Map of private subnet CIDRs by AZ suffix"
  type        = map(string)
  default = {
    a = "10.1.4.0/24"
    b = "10.1.5.0/24"
    c = "10.1.6.0/24"
  }
}

variable "cluster_name" {
  description = "name of cluster"
  type        = string
  default     = "cwave"
}

variable "cluster_version" {
  description = "version of cluster"
  type        = string
  default     = "1.32"
}

variable "environment" {
  description = "Environment name (e.g., dev, stg, prd)"
  type        = string
  default     = "dev"  # 필요한 경우 기본값 설정
}

variable "eks_namespace_roles" {
  description = "Map of EKS namespace roles and their configurations"
  type = map(object({
    name                = string
    environment         = string
    additional_policies = list(string)
  }))
  default = {}
}

variable "rds_backup_retention_period" {
  description = "backup retention"
  type        = number
  default     = 10
}
variable "rds_password" {
  description = "backup retention"
  type        = string
  default     = "user12345"
}
variable "rds_username" {
  description = "backup retention"
  type        = string
  default     = "user"
}

variable "rds_database_name" {
  description = "backup retention"
  type        = string
  default     = "istory"
}

variable "rds_max_allocated_storage" {
  description = "backup retention"
  type        = number
  default     = 100
}

variable "rds_allocated_storage" {
    description = "The allocated storage in gigabytes"
    type        = number
    default     = 20
}

variable "rds_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "8.0.35"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}