locals {
  region      = "us-east-2"
  name        = "skaf"
  environment = "prod"

}

module "eck" {
  source       = "../../"
  cluster_name = "cluster-name"
  eck_config = {
    hostname             = "eck.squareops.in"
    master_node_sc       = "gp2"
    data_hot_node_sc     = "gp2"
    data_warm_node_sc    = "gp2"
    kibana_node_count    = 1
    master_node_count    = 1
    data_hot_node_count  = 2
    data_warm_node_count = 2
    master_node_size     = "20Gi"
    data_hot_node_size   = "50Gi"
    data_warm_node_size  = "50Gi"
    eck_values           = file("./helm/eck.yaml")
    karpenter_enabled    = true
    karpenter_config = {
      private_subnet_name                  = "private-subnet-name"
      karpenter_ec2_capacity_type          = ["spot"]
      excluded_karpenter_ec2_instance_type = ["nano", "micro", "small"]
      karpenter_eck_values                 = file("./helm/karpenter.yaml")
    }

  }

  elastalert_enabled = true
  elastalert_config = {
    slack_webhook_url = ""
    elastalert_values = file("./helm/elastAlert.yaml")
  }
}
