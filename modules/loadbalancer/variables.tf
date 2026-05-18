variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for all load balancer resources"
  type        = string
}

variable "lb_sku" {
  description = "SKU for the Load Balancer and its Public IP"
  type        = string
  default     = "Standard"
}

variable "lb_frontend_port" {
  description = "Frontend port for the HTTP LB rule"
  type        = number
  default     = 80
}

variable "lb_backend_port" {
  description = "Backend port for the HTTP LB rule"
  type        = number
  default     = 80
}

variable "nat_frontend_port_start" {
  description = "Start of the frontend port range for SSH NAT rule"
  type        = number
  default     = 50000
}

variable "nat_frontend_port_end" {
  description = "End of the frontend port range for SSH NAT rule"
  type        = number
  default     = 50119
}
