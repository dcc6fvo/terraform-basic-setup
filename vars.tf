variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR value"
  default     = "192.168.0.0/24"
}

 
variable "private_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR value"
  default     = "192.168.1.0/24"
}

variable "az1" {
  type        = string
  description = "Availability Zone"
  default     = "sa-east-1a"
}

variable "az2" {
  type        = string
  description = "Availability Zone"
  default     = "sa-east-1b"
}

variable "az3" {
  type        = string
  description = "Availability Zone"
  default     = "sa-east-1c"
}