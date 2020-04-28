variable "vpc_cidr_block" {
  description = "address space of the network"
}

variable "environment" {
  description = "The system environment of the deployment. stage, test, pre-production, production"
}

variable "product" {
  description = "The product for which this deployment is under"
}

variable "public_app_subnet_cidr_a" {
  description = "cidr of the public subnet a"
}

variable "public_app_subnet_cidr_b" {
  description = "cidr of the public subnet b"
}

variable "private_db_subnet_cidr_a" {
  description = "cidr of the private subnet a for db"
}

variable "private_db_subnet_cidr_b" {
  description = "cidr of the private subnet b for db"
}


variable "private_db_subnet_cidr_c" {
  description = "cidr of the public subnet c"
}

variable "mysql_port" {
  description = "running port of mysql database"
}

variable "rds_subnetgroupname" {
  description = "RDS subnet group name"
}

variable "rds_paramgroupname" {
  description = "RDS parameter group"
}

variable "rds_storage_size" {
  description = "storage size for the db"
}

variable "rds_storage_type" {
  description = "storage type available in aws for rds"
}

variable "rds_engine" {
  description = "type of RDS engine. Mysql, Aurora, PostgreSQL, MSSQL"
}

variable "rds_engine_version" {
  description = "version of the database engine to be used"
}

variable "rds_instance_size" {
  description = "Type of instance to be used for the RDS"
}

variable "rds_name" {
  description = "Name to give to the RDS instance"
}

variable "rds_root_username" {
  description = "username of the root user of the database"
}

variable "rds_root_password" {
  description = "password of the root user"
}

variable "rds_multi_az" {
  default = true
  description = "whether single instance or multiple ones in different AZs"
}