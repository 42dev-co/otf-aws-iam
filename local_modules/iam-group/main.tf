locals {
  # Group name is only derived if the group is created
  group_name = var.create_group ? aws_iam_group.this[0].id : var.name
}

resource "aws_iam_group" "this" {
  count = var.create_group ? 1 : 0

  name = var.name
  path = var.path
}

resource "aws_iam_group_policy_attachment" "custom_arns" {
  count = var.create_group && length(var.custom_group_policy_arns) > 0 ? 1 : 0

  group      = local.group_name
  policy_arn = element(var.custom_group_policy_arns, count.index)
}

