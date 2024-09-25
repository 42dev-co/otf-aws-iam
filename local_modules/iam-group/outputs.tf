
output "group_arn" {
  description = "IAM group arn"
  value       = try(aws_iam_group.this[0].arn, "")
}

output "group_name" {
  description = "IAM group name"
  value       = try(aws_iam_group.this[0].name, var.name)
}