locals {
  name        = "elastic"
  region      = "eastus"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "eck" {
  source    = "https://github.com/sq-ia/terraform-kubernetes-elastic.git"
  namespace = "elastic-system"
  eck_config = {
    provider_type        = "azure"
    hostname             = ""
    eck_values           = file("./helm/eck.yaml")
    master_node_sc       = "infra-service-sc"
    data_hot_node_sc     = "infra-service-sc"
    data_warm_node_sc    = "infra-service-sc"
    master_node_size     = "20Gi"
    data_hot_node_size   = "50Gi"
    data_warm_node_size  = "50Gi"
    kibana_node_count    = 1
    master_node_count    = 1
    data_hot_node_count  = 1
    data_warm_node_count = 1
  }
  exporter_enabled   = false
  elastalert_enabled = false
  elastalert_config = {
    slack_webhook_url = ""
    elastalert_values = file("./helm/elastAlert.yaml")
  }
}
