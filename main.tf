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
  chart      = "eck-operator"
  timeout    = 600
  namespace  = var.namespace
  repository = "https://helm.elastic.co"
}


resource "helm_release" "elastic_stack" {
  depends_on = [kubernetes_namespace.elastic_system, helm_release.eck_operator]
  name       = "elastic-stack"
  chart      = "${path.module}/helm/elastic-stack"
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/elastic-stack/values.yaml", {
      eck_version             = "${var.eck_version}"
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
      s3_role_arn             = var.provider_type == "aws" ? var.role_arn : ""
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
  version    = var.chart_version
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

resource "helm_release" "elasticsearch_exporter" {
  depends_on = [data.kubernetes_secret.eck_secret]
  count      = var.exporter_enabled ? 1 : 0
  name       = "elasticsearch-exporter"
  chart      = "prometheus-elasticsearch-exporter"
  version    = "5.1.1"
  timeout    = 300
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  values = [
    file("${path.module}/helm/elasticsearch-exporter/elasticsearch-exporter.yaml")
  ]
}
