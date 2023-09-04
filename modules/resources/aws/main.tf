locals {
  oidc_provider = replace(
    data.aws_eks_cluster.kubernetes_cluster.identity[0].oidc[0].issuer,
    "/^https:///",
    ""
  )
}

data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "kubernetes_cluster" {
  name = var.cluster_name
}

data "kubernetes_secret" "eck_secret" {
  depends_on = [time_sleep.wait_60_sec]
  metadata {
    name      = "elasticsearch-es-elastic-user"
    namespace = var.namespace
  }
}

variable "cluster_name" {
  type        = string
  default     = "test"
  description = "Name of the EKS cluster to which the ECK stack should be deployed."

}

resource "aws_iam_role" "eck_role" {
  name = join("-", [var.cluster_name, "elastic-system"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:elastic-system:sa-elastic"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:ListBucket",
            "s3:DeleteObject",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

output "role_arn" {
  value = aws_iam_role.eck_role.arn
}