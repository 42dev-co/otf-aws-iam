# Automation goes here

locals {
  users = merge(
    [ 
      for f in fileset(path.module, "./resources/users/**/*.yaml") : 
      yamldecode(file("${path.module}/${f}"))
    ]...
  )

  groups = merge(
    [ 
      for f in fileset(path.module, "./resources/groups/**/*.yaml") : 
      yamldecode(file("${path.module}/${f}"))
    ]...
  )

  # Auto link policies define in iam_policy to the group
  group_policy_arns = merge([
    for k, v in local.groups :
    {
      for p in lookup(v, "policies", []) :
        "${k}-${p}" => { 
          group = k
          arn = try(module.iam_policy[p].arn, "")
        }
    }
  ]...)

  # Auto link users define in iam_users to the group
  group_users = {
    for k, v in local.groups :
    k => compact([
      for u in lookup(v, "users", []) :
      try(module.iam_user[u].iam_user_name, "")  
    ]) if length(lookup(v, "users", [])) > 0
  }

  # Auto link polcies define in iam_policy to the roles
  role_policy_arns = merge([
    for k, v in local.roles :
    {
      for p in lookup(v, "policies", []) :
        "${k}-${p}" => { 
          role = k
          arn = try(module.iam_policy[p].arn, "")
        }
    }
  ]...)

  # Get the names of policies from the files and file location
  policies = merge(
    [ 
      for f in fileset(path.module, "./resources/policies/*.yaml") : 
      yamldecode(file("${path.module}/${f}"))
    ]...
  )

  roles = merge(
    [ 
      for f in fileset(path.module, "./resources/roles/*.yaml") : 
      yamldecode(file("${path.module}/${f}"))
    ]...
  )
}


module "iam_user" {
  source  = "./local_modules/iam-user"
  
  for_each = local.users

  name = each.key

  create_iam_access_key         = try(each.value.create_iam_access_key, false)
  create_iam_user_login_profile = try(each.value.create_iam_user_login_profile, true)
  create_user                   = try(each.value.create_user, true)
  force_destroy                 = try(each.value.force_destroy, false)
  iam_access_key_status         = try(each.value.iam_access_key_status, null)
  password_length               = try(each.value.password_length, 20)
  password_reset_required       = try(each.value.password_reset_required, true)
  path                          = try(each.value.path, "/")
  permissions_boundary          = try(each.value.permissions_boundary, "")
  pgp_key                       = try(each.value.pgp_key, "")
  policy_arns                   = try(each.value.policy_arns, [])
  ssh_key_encoding              = try(each.value.ssh_key_encoding, "SSH")
  ssh_public_key                = try(each.value.ssh_public_key, "")
  upload_iam_user_ssh_key       = try(each.value.upload_iam_user_ssh_key, false)

  tags = merge(
    {Name=each.key, Email=each.value.email},
    try({AutomataticAccessKeys=each.value.automatic_access_key}, {}),
    try(each.value.tags, {}), var.default_tags
  )

} 

module "iam_policy" {
  source  = "./local_modules/iam-policy"

  for_each = local.policies

  name        = each.key

  create_policy = try(each.value.create_policy, true)
  description   = try(each.value.description, "Custom IAM Policy")
  name_prefix   = try(each.value.name_prefix, null)
  path          = try(each.value.path, "/")
  policy        = file("${path.module}/resources/policies/json/${each.key}.json")

  tags = merge(
    {Name=each.key},
    try(each.value.tags, {}), var.default_tags
  )
}


module "iam_group" {
  source  = "./local_modules/iam-group"

  for_each = local.groups

  name                                    = each.key
  create_group                            = try(each.value.create_group, true)
  custom_group_policy_arns                = try(each.value.custom_group_policy_arns, [])
  path                                    = try(each.value.path, "/")

  
  tags = merge(
    {Name=each.key},
    try(each.value.tags, {}), var.default_tags
  )

  depends_on = [ module.iam_policy, module.iam_user]
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each =  local.group_policy_arns
  
  group      = module.iam_group[each.value.group].group_name
  policy_arn = each.value.arn

  depends_on = [
    module.iam_group,
    module.iam_user
  ]
}

resource "aws_iam_group_membership" "this" {
 for_each = local.group_users

  group = each.key
  name  = each.key
  users = each.value

  depends_on = [ 
    module.iam_group,
    module.iam_user
   ]
}

module "iam_role" {
  source  = "./local_modules/iam-role"

  for_each = local.roles

  name                         = each.key
  create_role                  = try(each.value.create_role, true)
  path                         = try(each.value.path, "/")
  description                  = try(each.value.description, "")
  assume_role_policy           = file("${path.module}/resources/roles/json/${each.key}.json")  
  inline_policies              = try(each.value.inline_policies, {})
  managed_policy_arns          = try(each.value.managed_policy_arns, [])  
  permissions_boundary         = try(each.value.permissions_boundary, "")
  force_detach_policies        = try(each.value.force_detach_policies, false)
  max_session_duration         = try(each.value.max_session_duration, 3600) 
  
  tags = merge(
    {Name=each.key},
    try(each.value.tags, {}), var.default_tags
  )

  depends_on = [ module.iam_policy ]
}



resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.role_policy_arns
  
  role = module.iam_role[each.value.role].iam_role_name

  # We try to look up from the role_policies_search before we try to lookup on local policy resources
  policy_arn = each.value.arn

  depends_on = [
    module.iam_policy 
  ]
}
