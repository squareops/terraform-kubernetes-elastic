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
  values = [
    file("${path.module}/helm/operator/operator.yaml"),
    var.eck_config.operator_values
  ]
}


resource "helm_release" "elastic_stack" {
  depends_on = [kubernetes_namespace.elastic_system, helm_release.eck_operator]
  name       = "elastic-stack"
  chart      = "${path.module}/helm/elastic-stack"
  version    = "0.1.0"
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/elastic-stack/values.yaml", {
      eck_version                      = "${var.eck_version}"
      namespace                        = "${var.namespace}"
      hostname                         = "${var.eck_config.hostname}"
      es_master_node_size              = "${var.eck_config.master_node_size}"
      es_master_node_sc                = "${var.eck_config.master_node_sc}"
      es_data_hot_node_sc              = "${var.eck_config.data_hot_node_sc}"
      es_data_warm_node_sc             = "${var.eck_config.data_warm_node_sc}"
      es_master_node_count             = "${var.eck_config.master_node_count}"
      es_data_hot_node_count           = "${var.eck_config.data_hot_node_count}"
      es_data_warm_node_count          = "${var.eck_config.data_warm_node_count}"
      es_data_hot_node_size            = "${var.eck_config.data_hot_node_size}"
      es_data_warm_node_size           = "${var.eck_config.data_warm_node_size}"
      kibana_node_count                = "${var.eck_config.kibana_node_count}"
      s3_role_arn                      = var.provider_type == "aws" ? var.role_arn : ""
      aws_modules_enabled              = var.aws_modules_enabled
      filebeat_role_arn                = var.filebeat_role_arn
      application_index_name           = var.application_index_name
      application_input_type_key       = var.application_input_type_key
      application_input_type_value     = var.application_input_type_value
      database_index_name              = var.database_index_name
      mongodb_input_type_key           = var.mongodb_input_type_key
      mongodb_input_type_value         = var.mongodb_input_type_value
      mysql_input_type_key             = var.mysql_input_type_key
      mysql_input_type_value           = var.mysql_input_type_value
      redis_input_type_key             = var.redis_input_type_key
      redis_input_type_value           = var.redis_input_type_value
      rabbitmq_input_type_key          = var.rabbitmq_input_type_key
      rabbitmq_input_type_value        = var.rabbitmq_input_type_value
      aws_input_type_key               = var.aws_input_type_key
      aws_input_type_value             = var.aws_input_type_value
      ingress_nginx_controller_enabled = var.ingress_nginx_controller_enabled
      aws_cloudtrail_enabled           = var.aws_cloudtrail_enabled
      aws_elb_enabled                  = var.aws_elb_enabled
      aws_vpc_flow_logs_enabled        = var.aws_vpc_flow_logs_enabled
      aws_cloudwatch_logs_enabled      = var.aws_cloudwatch_logs_enabled
      aws_s3access_enabled             = var.aws_s3access_enabled
      cloudtrail_bucket_arn            = var.cloudtrail_bucket_arn
      cloudtrail_bucket_prefix         = var.cloudtrail_bucket_prefix
      vpc_flowlogs_bucket_arn          = var.vpc_flowlogs_bucket_arn
      vpc_flowlogs_bucket_prefix       = var.vpc_flowlogs_bucket_prefix
      elb_bucket_arn                   = var.elb_bucket_arn
      elb_bucket_prefix                = var.elb_bucket_prefix
      s3access_bucket_arn              = var.s3access_bucket_arn
      s3access_bucket_prefix           = var.s3access_bucket_prefix
      mongodb_enabled                  = var.mongodb_enabled
      mysql_enabled                    = var.mysql_enabled
      postgresql_enabled               = var.postgresql_enabled
      aws_index_enabled                = var.aws_index_enabled
      application_index_enabled        = var.application_index_enabled
      database_redis_index_enabled     = var.database_redis_index_enabled
      database_rabbitmq_index_enabled  = var.database_rabbitmq_index_enabled
      database_postgres_index_enabled  = var.database_postgres_index_enabled
      database_mongodb_index_enabled   = var.database_mongodb_index_enabled
      database_mysql_index_enabled     = var.database_mysql_index_enabled
      postgres_input_type_key          = var.postgres_input_type_key
      postgres_input_type_value        = var.postgres_input_type_value
      custom_index_enabled             = var.custom_index_enabled
      custom_index_name                = var.custom_index_name
      custom_input_type_key            = var.custom_input_type_key
      custom_input_type_value          = var.custom_input_type_value
      eckuser                          = "elastic"
      eckpassword                      = ""
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
  version    = var.helm_chart_version
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

resource "null_resource" "es_secret" {
  depends_on = [data.kubernetes_secret.eck_secret, time_sleep.wait_60_sec]
  provisioner "local-exec" {
    command = "kubectl patch beat filebeat -n ${var.namespace} --type merge -p '{\"spec\":{\"config\":{\"output.elasticsearch\":{\"password\":\"${data.kubernetes_secret.eck_secret.data["elastic"]}\"}}}}'"
  }
}

resource "null_resource" "es_aws_secret" {
  count      = var.aws_modules_enabled ? 1 : 0
  depends_on = [data.kubernetes_secret.eck_secret, time_sleep.wait_60_sec]
  provisioner "local-exec" {
    command = "kubectl patch beat filebeat-aws -n ${var.namespace} --type merge -p '{\"spec\":{\"config\":{\"output.elasticsearch\":{\"password\":\"${data.kubernetes_secret.eck_secret.data["elastic"]}\"}}}}'"
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
