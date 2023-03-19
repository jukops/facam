output "lb_controller_iam_arn" {
    value = aws_iam_role.eks_aws_lb_controller.arn
}

output "external_dns_iam_arn" {
    value = aws_iam_role.eks_external_dns.arn
}

output "handson_local_zone_id" {
    value = aws_route53_zone.handson_local.zone_id
}

#output "facam_efs_id" {
#    value = aws_efs_file_system.facam.id
#}

