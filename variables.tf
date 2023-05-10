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
  description = "Configurations for deploying the Elastic Cloud on Kubernetes (ECK) stack. "
}

variable "eck_version" {
  type        = string
  default     = "7.17.3"
  description = "Version of ECK to be deployed on Kubernetes."
}
variable "elastalert_config" {
  type = map(any)
  default = {
    slack_webhook_url = ""
    elastalert_values = ""
  }
  description = "Configurations for deploying the Elastalert tool, which is an alerting system for Elasticsearch."
}

variable "chart_version" {
  type        = string
  default     = "2.9.0"
  description = "Version of Helm chart to be used for deploying the ECK stack."
}
variable "elastalert_enabled" {
  type        = bool
  default     = false
  description = "Whether the Elastalert tool should be deployed along with the ECK stack or not. "
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name of the EKS cluster to which the ECK stack should be deployed."

}

variable "namespace" {
  type        = string
  default     = "elastic-system"
  description = "Name of the Kubernetes namespace where the ECK deployment will be deployed."
}
