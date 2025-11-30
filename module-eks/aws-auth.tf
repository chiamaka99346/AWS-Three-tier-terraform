resource "kubernetes_config_map" "aws_auth" {
  provider = kubernetes.eks

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(concat([
      {
        rolearn  = aws_iam_role.eks_node_group_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ], [
      for role in var.admin_role_arns : {
        rolearn  = role
        username = "admin"
        groups   = ["system:masters"]
      }
    ]))

    mapUsers = yamlencode([
      for user in var.admin_user_arns : {
        userarn  = user
        username = "admin"
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [aws_eks_node_group.eks_node_group]
}
