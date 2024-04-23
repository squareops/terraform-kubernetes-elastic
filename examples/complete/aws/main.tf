locals {
  name        = "elastic"
  region      = "ap-northeast-1"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "aws" {
  source           = "https://github.com/sq-ia/terraform-kubernetes-elastic.git//modules/resources/aws"
  eks_cluster_name = "dev-cluster"
}

module "eck" {
  source    = "https://github.com/sq-ia/terraform-kubernetes-elastic.git"
  namespace = local.name
  eck_config = {
    provider_type        = "aws"
    hostname             = "eck.squareops.in"
    eck_values           = file("./helm/eck.yaml")
    operator_values      = file("./helm/operator.yaml")
    master_node_sc       = "gp2"
    data_hot_node_sc     = "gp2"
    data_warm_node_sc    = "gp2"
    master_node_size     = "20Gi"
    data_hot_node_size   = "50Gi"
    data_warm_node_size  = "50Gi"
    kibana_node_count    = 1
    master_node_count    = 1
    data_hot_node_count  = 2
    data_warm_node_count = 2
    role_arn             = module.aws.role_arn
  }
  exporter_enabled   = true
  elastalert_enabled = true
  elastalert_config = {
    slack_webhook_url = ""
    elastalert_values = file("./helm/elastAlert.yaml")
  }
  # Multiple Indices
  application_index_enabled       = true
  aws_index_enabled               = false
  database_mysql_index_enabled    = true
  database_mongodb_index_enabled  = false
  database_redis_index_enabled    = false
  database_rabbitmq_index_enabled = false
  database_postgres_index_enabled = false
  application_index_name          = "application"
  database_index_name             = "database"
  application_input_type_key      = "kubernetes.namespace"
  application_input_type_value    = "robotshop"
  mongodb_input_type_key          = "kubernetes.namespace"
  mongodb_input_type_value        = "mongodb"
  mysql_input_type_key            = "kubernetes.namespace"
  mysql_input_type_value          = "mysql"
  redis_input_type_key            = "kubernetes.namespace"
  redis_input_type_value          = "redis"
  rabbitmq_input_type_key         = "kubernetes.namespace"
  rabbitmq_input_type_value       = "rabbitmq"
  postgres_input_type_key         = "kubernetes.namespace"
  postgres_input_type_value       = "postgres"
  custom_index_enabled            = true
  custom_index_name               = "mongo"
  custom_input_type_key           = "kubernetes.namespace"
  custom_input_type_value         = "ingress-nginx"
  # Note: If you enabled "aws" index, you won't be able to visualize AWS modules kibana dashboards.
  aws_input_type_key   = "input.type"
  aws_input_type_value = "aws-s3"
  # Filebeat Modules
  aws_modules_enabled              = true
  ingress_nginx_controller_enabled = true
  mongodb_enabled                  = true
  mysql_enabled                    = true
  postgresql_enabled               = true
  filebeat_role_arn                = module.aws.filebeat_role_arn
  aws_cloudtrail_enabled           = true
  cloudtrail_bucket_arn            = ""
  cloudtrail_bucket_prefix         = ""
  aws_elb_enabled                  = false
  elb_bucket_arn                   = ""
  elb_bucket_prefix                = ""
  aws_vpc_flow_logs_enabled        = true
  vpc_flowlogs_bucket_arn          = ""
  vpc_flowlogs_bucket_prefix       = ""
  aws_s3access_enabled             = true
  s3access_bucket_arn              = ""
  s3access_bucket_prefix           = ""
}
