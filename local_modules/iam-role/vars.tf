variable "create_role" {
  description = "Whether to create the IAM role"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the role"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "path" {
  description = "The path of the role in IAM"
  type        = string
  default     = "/"
}

variable "description" {
  description = "The description of the role"
  type        = string
  default     = "IAM Role"
}

variable "assume_role_policy" {
  description = "The assume role policy document"
  type        = string
  default     = ""
}

variable "inline_policies" {
  description = "The inline policy document"
  default     = {}
}

variable "managed_policy_arns" {
  description = "List of IAM policies ARNs to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "force_detach_policies" {
  description = "Whether to force detach policies before deleting the role"
  type        = bool
  default     = false
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role"
  type        = number
  default     = null
}

