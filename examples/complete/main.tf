locals {
  region = "us-east-2"
}

module "eck" {
  source       = "../../"
  cluster_name = "dev-skaf"
  eck_config = {
    hostname          = "eck.dev.skaf.squareops.in"
    eck_values        = file("./helm/eck.yaml")
    karpenter_enabled = true
    karpenter_config = {
      private_subnet_name    = "dev-skaf-private-subnet"
      instance_capacity_type = ["spot"]
      excluded_instance_type = ["nano", "micro", "small"]
      karpenter_eck_values   = file("./helm/karpenter.yaml")
    }
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
  }

  elastalert_enabled = false
  elastalert_config = {
    slack_webhook_url = ""
    elastalert_values = file("./helm/elastAlert.yaml")
  }
}
