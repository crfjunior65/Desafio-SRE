output "node_group_ids" {
  value = { for k, v in aws_eks_node_group.main : k => v.id }
}

output "node_group_arns" {
  value = { for k, v in aws_eks_node_group.main : k => v.arn }
}
