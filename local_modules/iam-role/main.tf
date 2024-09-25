resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0
  
  name                  = var.name
  name_prefix           = var.name_prefix
  path                  = var.path
  assume_role_policy    = var.assume_role_policy
  description           = var.description
  
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  managed_policy_arns    = var.managed_policy_arns
  
  dynamic "inline_policy" {
      for_each = var.inline_policies
      content {
          name    = inline_policy.key
          policy  = inline_policy.value
      }
  }
  
  tags                = var.tags
}