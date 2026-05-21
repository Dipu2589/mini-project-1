variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for all networking resources"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the public subnet"
  type        = string
  default     = "10.0.0.0/20"
}

variable "sg_ports" {
  type = list(number)
  default = [ 443,80,22 ]
}
