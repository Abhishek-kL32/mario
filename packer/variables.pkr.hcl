variable "ami_id" {

  type        = string
  description = "default ami will be Amazon Linux"
#  default     = "ami-0aee0743bf2e81172"
  default     = "ami-0a7cf821b91bcccbc"
}

variable "project_name" {

  type        = string
  description = "Name of Project"
  default     = "zomato"
}

variable "project_env" {

  type        = string
  description = "Project Environment"
  default     = "prod"
}

variable "region" {

  type        = string
  description = "Project Environment"
  default     = "ap-south-1"
}

variable "instance_type" {

  type        = string
  description = "Free tyre instance type"
  default     = "t2.micro"
}

variable "version_num" {

  type        = number
  description = "Project Environment"
  default     = "1.0"
}

#locals {
#  image_name   = "data.amazon-ami.zomato_prod + 0.1"
#  }

locals {
   timestamp    = "${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
   image_name   = "${var.project_name}-${var.project_env}-${local.timestamp}"
 }

