locals {
  oidc_provider = replace(
    data.aws_eks_cluster.kubernetes_cluster.identity[0].oidc[0].issuer,
    "/^https:///",
    ""
  )
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "kubernetes_cluster" {
  name = var.cluster_name
}



resource "kubernetes_namespace" "elastic_system" {
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "eck_operator" {
  depends_on = [
    kubernetes_namespace.elastic_system
  ]
  name       = "elastic-operator"
  repository = "https://helm.elastic.co"
  chart      = "eck-operator"
  namespace  = var.namespace
  timeout    = 600
}


resource "helm_release" "elastic_stack" {
  depends_on = [kubernetes_namespace.elastic_system, helm_release.eck_operator]
  name       = "elastic-stack"
  chart      = "${path.module}/helm/elastic-stack"
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/elastic-stack/values.yaml", {
      elastic_stack_version   = "${var.elastic_stack_version}"
      namespace               = "${var.namespace}"
      hostname                = "${var.eck_config.hostname}"
      es_master_node_size     = "${var.eck_config.master_node_size}"
      es_master_node_sc       = "${var.eck_config.master_node_sc}"
      es_data_hot_node_sc     = "${var.eck_config.data_hot_node_sc}"
      es_data_warm_node_sc    = "${var.eck_config.data_warm_node_sc}"
      es_master_node_count    = "${var.eck_config.master_node_count}"
      es_data_hot_node_count  = "${var.eck_config.data_hot_node_count}"
      es_data_warm_node_count = "${var.eck_config.data_warm_node_count}"
      es_data_hot_node_size   = "${var.eck_config.data_hot_node_size}"
      es_data_warm_node_size  = "${var.eck_config.data_warm_node_size}"
      kibana_node_count       = "${var.eck_config.kibana_node_count}"
      s3_role_arn             = aws_iam_role.eck_role.arn,
    }),
    var.eck_config.eck_values
  ]
}

resource "helm_release" "elastalert" {
  count = var.elastalert_enabled ? 1 : 0
  depends_on = [
    helm_release.elastic_stack
  ]

  name       = "elastalert"
  chart      = "elastalert2"
  timeout    = 600
  version    = var.elastalert_chart_version
  namespace  = var.namespace
  repository = "https://jertel.github.io/elastalert2/"
  values = [
    templatefile("${path.module}/helm/elastalert2/values.yaml", {
      eckpassword       = "${data.kubernetes_secret.eck_secret.data["elastic"]}"
      slack_webhook_url = var.elastalert_config.slack_webhook_url
    }),
    var.elastalert_config.elastalert_values
  ]
}

resource "helm_release" "karpenter_provisioner" {
  count   = var.eck_config.karpenter_enabled ? 1 : 0
  name    = "karpenter-provisioner-eck"
  chart   = "${path.module}/helm/karpenter_provisioner/"
  timeout = 600
  values = [
    templatefile("${path.module}/helm/karpenter_provisioner/values.yaml", {
      private_subnet_name                  = var.eck_config.karpenter_config.private_subnet_name,
      cluster_name                         = var.cluster_name,
      karpenter_ec2_capacity_type          = "[${join(",", [for s in var.eck_config.karpenter_config.instance_capacity_type : format("%s", s)])}]",
      excluded_karpenter_ec2_instance_type = "[${join(",", var.eck_config.karpenter_config.excluded_instance_type)}]"
    }),
    var.eck_config.karpenter_config.karpenter_eck_values
  ]
}

resource "time_sleep" "wait_60_sec" {
  depends_on      = [helm_release.elastic_stack]
  create_duration = "60s"
}

data "kubernetes_secret" "eck_secret" {
  depends_on = [time_sleep.wait_60_sec]
  metadata {
    name      = "elasticsearch-es-elastic-user"
    namespace = var.namespace
  }
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
