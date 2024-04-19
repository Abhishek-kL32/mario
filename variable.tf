variable "instance_type" {

  type        = string
  description = "instance type for launching ec2 in auto-scaling group"
}

variable "project_name" {

  type        = string
  description = "name of the project"
}

variable "region" {

  type        = string
  description = " region for which the infra need to be deployed "
}

variable "project_env" {

  type        = string
  description = "ENV of the project"
}

variable "vpc_cidr_block" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.0.0/16"
}

variable "public_subnet-1" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.32.0/19"
}

variable "public_subnet-2" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.64.0/19"
}

variable "public_subnet-3" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.96.0/19"
}

variable "private_subnet-1" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.128.0/19"
}

variable "private_subnet-2" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.160.0/19"
}

variable "private_subnet-3" {

  type        = string
  description = "VPC CiDr block"
  default     = "172.16.192.0/19"
}

variable "hostname" {

  type        = string
  description = "sub domain name for the website"
}

variable "hosted_zone_name" {

  type        = string
  description = "main domain name"
}
