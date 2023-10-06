output "role_arn" {
  value = aws_iam_role.eck_role.arn
}

output "filebeat_role_arn" {
  value = aws_iam_role.filebeat_role.arn
}
