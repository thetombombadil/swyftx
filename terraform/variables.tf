variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "subnets" {
  type = list(map(string))
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
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
