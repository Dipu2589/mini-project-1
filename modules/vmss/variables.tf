variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for all VMSS resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to attach VM NICs to"
  type        = string
}

variable "lb_backend_address_pool_id" {
  description = "ID of the Load Balancer backend address pool"
  type        = string
}

variable "lb_id" {
  description = "ID of the Load Balancer (used for dependency ordering)"
  type        = string
}

# VM Configuration
variable "vm_sku" {
  description = "SKU size for VMs in the scale set"
  type        = string
  default     = "Standard_B1s"
}

variable "instance_count" {
  description = "Initial number of VM instances"
  type        = number
  default     = 3
}

variable "admin_username" {
  description = "Admin username for the VM instances"
  type        = string
  default     = "azureuser"
}

# OS Image
variable "image_publisher" {
  description = "Publisher of the OS image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the OS image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the OS image"
  type        = string
  default     = "22-04-LTS-gen2"
}

variable "image_version" {
  description = "Version of the OS image"
  type        = string
  default     = "latest"
}

# Autoscale Settings
variable "autoscale_default" {
  description = "Default number of instances for autoscale"
  type        = number
  default     = 3
}

variable "autoscale_min" {
  description = "Minimum number of instances for autoscale"
  type        = number
  default     = 1
}

variable "autoscale_max" {
  description = "Maximum number of instances for autoscale"
  type        = number
  default     = 5
}

variable "scale_out_cpu_threshold" {
  description = "CPU percentage threshold to trigger scale-out"
  type        = number
  default     = 80
}

variable "scale_out_count" {
  description = "Number of instances to add on scale-out"
  type        = number
  default     = 5
}

variable "scale_in_cpu_threshold" {
  description = "CPU percentage threshold to trigger scale-in"
  type        = number
  default     = 25
}

variable "scale_in_count" {
  description = "Number of instances to remove on scale-in"
  type        = number
  default     = 1
}
