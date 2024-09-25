variable "create_user" {
  description = "Whether to create the IAM user"
  type        = bool
  default     = true
}

variable "create_iam_user_login_profile" {
  description = "Whether to create IAM user login profile"
  type        = bool
  default     = true
}

variable "create_iam_access_key" {
  description = "Whether to create IAM access key"
  type        = bool
  default     = true
}

variable "name" {
  description = "Desired name for the IAM user"
  type        = string
}

variable "path" {
  description = "Desired path for the IAM user"
  type        = string
  default     = "/"
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile, or MFA devices."
  type        = bool
  default     = false
}

variable "pgp_key" {
  description = "Base-64 encoded PGP public key or Keybase username for encryption."
  type        = string
  default     = ""
}

variable "iam_access_key_status" {
  description = "Access key status to apply."
  type        = string
  default     = "Active"
}

variable "password_reset_required" {
  description = "Whether the user should reset the password on first login."
  type        = bool
  default     = true
}

variable "password_length" {
  description = "The length of the generated password"
  type        = number
  default     = 20
}

variable "upload_iam_user_ssh_key" {
  description = "Whether to upload a public SSH key to the IAM user"
  type        = bool
  default     = false
}

variable "ssh_key_encoding" {
  description = "The encoding of the SSH public key"
  type        = string
  default     = "SSH"
}

variable "ssh_public_key" {
  description = "The SSH public key to upload to the IAM user"
  type        = string
  default     = ""
}

variable "policy_arns" {
  description = "A list of policy ARNs to attach to the user"
  type        = list(string)
  default     = []
}

variable "permissions_boundary" {
  description = "An optional permissions boundary for the IAM user."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the IAM user."
  type        = map(string)
  default     = {}
}
