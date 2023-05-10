variable "eck_config" {
  type = any
  default = {
    hostname             = ""
    master_node_sc       = "gp2"
    data_hot_node_sc     = "gp2"
    data_warm_node_sc    = "gp2"
    kibana_node_count    = 1
    master_node_count    = 1
    data_hot_node_count  = 1
    data_warm_node_count = 1
    master_node_size     = "10Gi"
    data_hot_node_size   = "20Gi"
    data_warm_node_size  = "20Gi"
    karpenter_enabled    = ""
    eck_values           = ""
    karpenter_config = {
      private_subnet_name    = ""
      instance_capacity_type = ["spot"]
      excluded_instance_type = ["nano", "micro", "small"]
      karpenter_eck_values   = ""
    }
  }
  description = "Elastic Stack configurations"
}

variable "elastic_stack_version" {
  description = "Elastic Stack version"
  type        = string
  default     = "7.17.3"
}
variable "elastalert_config" {
  type = map(any)
  default = {
    slack_webhook_url = ""
    elastalert_values = ""
  }
  description = "Elastalert configurations"
}

variable "elastalert_chart_version" {
  description = "value"
  default     = "2.9.0"
  type        = string

}
variable "elastalert_enabled" {
  default     = false
  type        = bool
  description = "Set true to deploy elastalert for ECK Stack"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "stg-msa-reff"
}

variable "namespace" {
  description = "Namespace in which Elastic Stack will be deployed"
  type        = string
  default     = "elastic-system"
}
