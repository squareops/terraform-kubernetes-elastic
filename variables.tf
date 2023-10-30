variable "eck_config" {
  type = any
  default = {
    hostname             = ""
    master_node_sc       = "gp2"
    data_hot_node_sc     = "gp2"
    data_warm_node_sc    = "gp2"
    kibana_node_count    = 1
    master_node_count    = 3
    data_hot_node_count  = 1
    data_warm_node_count = 1
    master_node_size     = "10Gi"
    data_hot_node_size   = "20Gi"
    data_warm_node_size  = "20Gi"
    eck_values           = ""
    eckuser              = "elastic"
    eckpassword          = ""
    namespace            = "elastic-system"
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

variable "exporter_enabled" {
  type        = bool
  default     = true
  description = "Whether the ECK exporter should be deployed along with the ECK stack or not. "
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

variable "provider_type" {
  type        = string
  default     = ""
  description = "Choose what type of provider you want (aws, gcp)" // SUPPORTS ONLY: aws, gcp, azure
}

variable "role_arn" {
  type        = string
  default     = ""
  description = "The s3 bucket role arn for the aws bucket provider" // SUPPORTS ONLY: aws, gcp
}

variable "application_index_name" {
  description = "The index name for the application logs"
  type        = string
  default     = ""
}

variable "application_input_type_key" {
  description = "The key used to identify the application input type"
  type        = string
  default     = ""
}

variable "application_input_type_value" {
  description = "The value associated with the application input type"
  type        = string
  default     = ""
}

variable "database_index_name" {
  description = "The index name for the database logs"
  type        = string
  default     = ""
}

variable "mongodb_input_type_key" {
  description = "The key used to identify the database input type"
  type        = string
  default     = ""
}

variable "mysql_input_type_key" {
  description = "The key used to identify the database input type"
  type        = string
  default     = ""
}

variable "redis_input_type_key" {
  description = "The key used to identify the database input type"
  type        = string
  default     = ""
}

variable "rabbitmq_input_type_key" {
  description = "The key used to identify the database input type"
  type        = string
  default     = ""
}

variable "mongodb_input_type_value" {
  description = "The value associated with the MongoDB input type"
  type        = string
  default     = ""
}

variable "mysql_input_type_value" {
  description = "The value associated with the MySQL input type"
  type        = string
  default     = ""
}

variable "redis_input_type_value" {
  description = "The value associated with the Redis input type"
  type        = string
  default     = ""
}

variable "rabbitmq_input_type_value" {
  description = "The value associated with the RabbitMQ input type"
  type        = string
  default     = ""
}

variable "aws_input_type_key" {
  description = "The key used to identify the AWS input type"
  type        = string
  default     = ""
}

variable "aws_input_type_value" {
  description = "The value associated with the AWS input type"
  type        = string
  default     = ""
}

variable "ingress_nginx_controller_enabled" {
  description = "Enable or disable Ingress Nginx Controller"
  type        = bool
  default     = false
}

variable "aws_cloudtrail_enabled" {
  description = "Enable or disable AWS CloudTrail"
  type        = bool
  default     = false
}

variable "aws_elb_enabled" {
  description = "Enable or disable AWS Elastic Load Balancer"
  type        = bool
  default     = false
}

variable "aws_vpc_flow_logs_enabled" {
  description = "Enable or disable AWS VPC Flow Logs"
  type        = bool
  default     = false
}

variable "aws_cloudwatch_logs_enabled" {
  description = "Enable or disable AWS CloudWatch Logs"
  type        = bool
  default     = false
}

variable "aws_s3access_enabled" {
  description = "Enable or disable AWS S3 Access"
  type        = bool
  default     = false
}

variable "aws_modules_enabled" {
  description = "Enable or disable AWS Modules"
  type        = bool
  default     = false
}

variable "elb_bucket_arn" {
  description = "The ARN of the ELB S3 bucket"
  type        = string
  default     = ""
}

variable "elb_bucket_prefix" {
  description = "The prefix for objects in the ELB S3 bucket"
  type        = string
  default     = ""
}

variable "vpc_flowlogs_bucket_arn" {
  description = "The ARN of the VPC Flow Logs S3 bucket"
  type        = string
  default     = ""
}

variable "vpc_flowlogs_bucket_prefix" {
  description = "The prefix for objects in the VPC Flow Logs S3 bucket"
  type        = string
  default     = ""
}

variable "cloudtrail_bucket_arn" {
  description = "The ARN of the CloudWatch S3 bucket"
  type        = string
  default     = ""
}

variable "cloudtrail_bucket_prefix" {
  description = "The prefix for objects in the CloudWatch S3 bucket"
  type        = string
  default     = ""
}

variable "s3access_bucket_arn" {
  description = "The ARN of the S3 Access S3 bucket"
  type        = string
  default     = ""
}

variable "s3access_bucket_prefix" {
  description = "The prefix for objects in the S3 Access S3 bucket"
  type        = string
  default     = ""
}

variable "mongodb_enabled" {
  type        = bool
  default     = false
  description = "Whether the mongodb filebeat module should be deployed along with the ECK stack or not. "
}

variable "mysql_enabled" {
  type        = bool
  default     = false
  description = "Whether the mysql filebeat module should be deployed along with the ECK stack or not. "
}

variable "postgresql_enabled" {
  type        = bool
  default     = false
  description = "Whether the postgresql filebeat module should be deployed along with the ECK stack or not. "
}

variable "filebeat_role_arn" {
  type        = string
  default     = ""
  description = "AWS filebeat role arn for authentication aws modules"
}

variable "database_postgres_index_enabled" {
  type        = bool
  default     = false
  description = "Database postgres index enabling"
}

variable "postgres_input_type_key" {
  description = "The value associated with the Postgres input type"
  type        = string
  default     = ""
}

variable "postgres_input_type_value" {
  description = "The value associated with the postgres input type"
  type        = string
  default     = ""
}

variable "database_redis_index_enabled" {
  type        = bool
  default     = false
  description = "Redis index enabling"
}

variable "database_rabbitmq_index_enabled" {
  type        = bool
  default     = false
  description = "Rabbitmq index enabling"
}

variable "database_mysql_index_enabled" {
  type        = bool
  default     = false
  description = "MYSQL index enabling"
}

variable "database_mongodb_index_enabled" {
  type        = bool
  default     = false
  description = "Database mongodb index enabling"
}

variable "aws_index_enabled" {
  type        = bool
  default     = false
  description = "AWS services index enabling"
}

variable "application_index_enabled" {
  type        = bool
  default     = false
  description = "Application index enabling"
}
