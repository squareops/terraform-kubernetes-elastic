locals {
  name        = "elastic"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "aws" {
  source       = "https://github.com/sq-ia/terraform-kubernetes-elastic.git//modules/resources/aws"
  cluster_name = ""
}

module "eck" {
  source    = "https://github.com/sq-ia/terraform-kubernetes-elastic.git"
  namespace = "elastic-system"
  eck_config = {
    provider_type        = "aws"
    hostname             = "eck.squareops.in"
    eck_values           = file("./helm/eck.yaml")
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
  elastalert_enabled = false
  elastalert_config = {
    slack_webhook_url = ""
    elastalert_values = file("./helm/elastAlert.yaml")
  }
}
