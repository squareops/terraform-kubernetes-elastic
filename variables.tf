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
    karpenter_config = {
      subnet_selector_name                 = ""
      sg_selector_name                     = ""
      karpenter_ec2_capacity_type          = [""]
      excluded_karpenter_ec2_instance_type = [""]
      karpenter_eck_values                 = ""
    }
  }
  description = "ECK configurations"
}

variable "eck_version" {
  description = "Enter eck version"
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

variable "chart_version" {
  description = "value"
  default     = "2.9.0"
  type        = string

}
variable "elastalert_enabled" {
  default     = false
  type        = bool
  description = "Set true to deploy elastalert for eck stack"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "stg-msa-reff"
}

variable "namespace" {
  description = "Enter namespace name"
  type        = string
  default     = "elastic-system"
}
