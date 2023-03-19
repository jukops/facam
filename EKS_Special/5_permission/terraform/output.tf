output "developer_role_arn" {
    value = aws_iam_role.developer_role.arn
}

output "devops_role_arn" {
    value = aws_iam_role.devops_role.arn
}
