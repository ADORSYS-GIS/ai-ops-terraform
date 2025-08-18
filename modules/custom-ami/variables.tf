variable "ami_name" {
  description = "The name of the custom AMI to be created."
  type        = string
}

variable "base_ami_version" {
  description = "The version of the base AMI to use. This is used to construct the AMI name filter."
  type        = string
}

variable "build_instance_type" {
  description = "The instance type to use for the AMI build."
  type        = string
  default     = "t3.medium"
}

variable "component_version" {
  description = "The version for the Image Builder component."
  type        = string
  default     = "1.0.0"
}

variable "customization_script_path" {
  description = "Path to the shell script for customizing the AMI."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "The ID of the subnet to use for the build instance."
  type        = string
  nullable    = false
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the build instance."
  type        = list(string)
  default     = []
}
