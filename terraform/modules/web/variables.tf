variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "service_name" {
  type    = string
  default = "nginx"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "enable_ssm" {
  type        = bool
  default     = true
  description = "Creates resources required for SSM connect to instance"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
