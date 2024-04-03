## Elastic Cloud Kubernetes
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>

This ECK module is a Kubernetes operator for Elasticsearch and Kibana that simplifies the deployment, management, and scaling of Elasticsearch and Kibana clusters in Kubernetes environments. The ECK module allows you to easily create and configure Elasticsearch and Kibana clusters, and provides customization options such as persistent volume claim templates and storage classes. Additionally, the ECK module provides security features such as encryption and authentication for Elasticsearch and Kibana clusters. With the ECK module, you can manage Elasticsearch and Kibana clusters in a scalable and efficient manner, while also ensuring the security of your data.

## Important Notes:
This module is compatible with EKS, AKS & GKE which is great news for users deploying the module on an AWS, Azure & GCP cloud. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.

## Supported Versions Table:

| Resources             |  Helm Chart Version                |     K8s supported version (EKS, AKS & GKE)                       |  
| :-----:               | :---                               |         :---                                     |
| Elastic-Operator      | **2.7.0**                          |    **1.23**,**1.24**,**1.25**,**1.26**,**1.27**           |
| ECK                   | **7.17.3**                         |    **1.23**,**1.24**,**1.25**,**1.26**,**1.27**           |
| Elastalert2           | **2.9.0**                          |    **1.23**,**1.24**,**1.25**,**1.26**,**1.27**           |


## Usage Example

```hcl
module "aws" {
  source = "https://github.com/sq-ia/terraform-kubernetes-elastic.git//modules/resources/aws"
  cluster_name     = "prod-eks"
}

module "eck" {
  source       = "https://github.com/sq-ia/terraform-kubernetes-elastic.git"
  namespace    = "elastic-system"
  eck_config = {
    provider_type        = "aws"
    hostname             = "eck.squareops.in"
    eck_values           = ""
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
    elastalert_values = ""
  }
    # Multiple Indices
  application_index_enabled       = true
  aws_index_enabled               = false
  database_mysql_index_enabled    = false
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
  # Note: If you enabled "aws" index, you won't be able to visualize AWS modules kibana dashboards.
  aws_input_type_key   = "input.type"
  aws_input_type_value = "aws-s3"
  # Filebeat Modules
  ingress_nginx_controller_enabled = true
  mongodb_enabled                  = true
  mysql_enabled                    = true
  postgresql_enabled               = false
  filebeat_role_arn                = module.aws.filebeat_role_arn
  aws_cloudtrail_enabled           = false
  cloudtrail_bucket_arn            = "arn:s3::xxxxxxx"
  cloudtrail_bucket_prefix         = "logs/"
  aws_elb_enabled                  = false
  elb_bucket_arn                   = "arn:s3::xxxxxxx"
  elb_bucket_prefix                = "access-logs/"
  aws_vpc_flow_logs_enabled        = false
  vpc_flowlogs_bucket_arn          = "arn:s3::xxxxxxx"
  vpc_flowlogs_bucket_prefix       = "vpc-logs/"
  aws_s3access_enabled             = false
  s3access_bucket_arn              = "arn:s3::xxxxxxx"
  s3access_bucket_prefix           = "s3-access/"
}


```
- Refer [AWS examples](https://github.com/sq-ia/terraform-kubernetes-elastic/tree/main/examples/complete/aws) for more details.
- Refer [Azure examples](https://github.com/sq-ia/terraform-kubernetes-elastic/tree/main/examples/complete/azure) for more details.
- Refer [GCP examples](https://github.com/sq-ia/terraform-kubernetes-elastic/tree/main/examples/complete/gcp) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/sq-ia/terraform-kubernetes-elastic/blob/main/IAM.md)

## Elast Alert

Elastic Alert is an open-source tool that enables real-time monitoring and detection of changes in Elasticsearch data. It is designed to work with Elasticsearch clusters and is part of the Elastic Stack. Elastic Alert allows you to define rules and thresholds to trigger alerts based on specific conditions in your Elasticsearch data.

Using Elast Alert, you can monitor your Elasticsearch data in real-time and receive alerts when certain conditions are met. For example, you might use Elast Alert to monitor your application logs for a certain number of errors in a given time period or to monitor for changes in system performance.

Elast Alert is highly configurable and can be customized to meet a wide range of monitoring use cases. It includes support for various alerting channels, such as email, Slack, PagerDuty, and more. Additionally, Elast Alert can be extended with custom actions, allowing you to execute custom scripts or webhook integrations when alerts are triggered.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.eck_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elastalert](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elastic_stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elasticsearch_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.elastic_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.es_aws_secret](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.es_secret](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_60_sec](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [kubernetes_secret.eck_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_index_enabled"></a> [application\_index\_enabled](#input\_application\_index\_enabled) | Application index enabling | `bool` | `false` | no |
| <a name="input_application_index_name"></a> [application\_index\_name](#input\_application\_index\_name) | The index name for the application logs | `string` | `""` | no |
| <a name="input_application_input_type_key"></a> [application\_input\_type\_key](#input\_application\_input\_type\_key) | The key used to identify the application input type | `string` | `""` | no |
| <a name="input_application_input_type_value"></a> [application\_input\_type\_value](#input\_application\_input\_type\_value) | The value associated with the application input type | `string` | `""` | no |
| <a name="input_aws_cloudtrail_enabled"></a> [aws\_cloudtrail\_enabled](#input\_aws\_cloudtrail\_enabled) | Enable or disable AWS CloudTrail | `bool` | `false` | no |
| <a name="input_aws_cloudwatch_logs_enabled"></a> [aws\_cloudwatch\_logs\_enabled](#input\_aws\_cloudwatch\_logs\_enabled) | Enable or disable AWS CloudWatch Logs | `bool` | `false` | no |
| <a name="input_aws_elb_enabled"></a> [aws\_elb\_enabled](#input\_aws\_elb\_enabled) | Enable or disable AWS Elastic Load Balancer | `bool` | `false` | no |
| <a name="input_aws_index_enabled"></a> [aws\_index\_enabled](#input\_aws\_index\_enabled) | AWS services index enabling | `bool` | `false` | no |
| <a name="input_aws_input_type_key"></a> [aws\_input\_type\_key](#input\_aws\_input\_type\_key) | The key used to identify the AWS input type | `string` | `""` | no |
| <a name="input_aws_input_type_value"></a> [aws\_input\_type\_value](#input\_aws\_input\_type\_value) | The value associated with the AWS input type | `string` | `""` | no |
| <a name="input_aws_modules_enabled"></a> [aws\_modules\_enabled](#input\_aws\_modules\_enabled) | Enable or disable AWS Modules | `bool` | `false` | no |
| <a name="input_aws_s3access_enabled"></a> [aws\_s3access\_enabled](#input\_aws\_s3access\_enabled) | Enable or disable AWS S3 Access | `bool` | `false` | no |
| <a name="input_aws_vpc_flow_logs_enabled"></a> [aws\_vpc\_flow\_logs\_enabled](#input\_aws\_vpc\_flow\_logs\_enabled) | Enable or disable AWS VPC Flow Logs | `bool` | `false` | no |
| <a name="input_cloudtrail_bucket_arn"></a> [cloudtrail\_bucket\_arn](#input\_cloudtrail\_bucket\_arn) | The ARN of the CloudWatch S3 bucket | `string` | `""` | no |
| <a name="input_cloudtrail_bucket_prefix"></a> [cloudtrail\_bucket\_prefix](#input\_cloudtrail\_bucket\_prefix) | The prefix for objects in the CloudWatch S3 bucket | `string` | `""` | no |
| <a name="input_custom_index_enabled"></a> [custom\_index\_enabled](#input\_custom\_index\_enabled) | Custom index enabling | `bool` | `false` | no |
| <a name="input_custom_index_name"></a> [custom\_index\_name](#input\_custom\_index\_name) | Custom index name | `string` | `""` | no |
| <a name="input_custom_input_type_key"></a> [custom\_input\_type\_key](#input\_custom\_input\_type\_key) | Custom index key name | `string` | `""` | no |
| <a name="input_custom_input_type_value"></a> [custom\_input\_type\_value](#input\_custom\_input\_type\_value) | Custom index value name | `string` | `""` | no |
| <a name="input_database_index_name"></a> [database\_index\_name](#input\_database\_index\_name) | The index name for the database logs | `string` | `""` | no |
| <a name="input_database_mongodb_index_enabled"></a> [database\_mongodb\_index\_enabled](#input\_database\_mongodb\_index\_enabled) | Database mongodb index enabling | `bool` | `false` | no |
| <a name="input_database_mysql_index_enabled"></a> [database\_mysql\_index\_enabled](#input\_database\_mysql\_index\_enabled) | MYSQL index enabling | `bool` | `false` | no |
| <a name="input_database_postgres_index_enabled"></a> [database\_postgres\_index\_enabled](#input\_database\_postgres\_index\_enabled) | Database postgres index enabling | `bool` | `false` | no |
| <a name="input_database_rabbitmq_index_enabled"></a> [database\_rabbitmq\_index\_enabled](#input\_database\_rabbitmq\_index\_enabled) | Rabbitmq index enabling | `bool` | `false` | no |
| <a name="input_database_redis_index_enabled"></a> [database\_redis\_index\_enabled](#input\_database\_redis\_index\_enabled) | Redis index enabling | `bool` | `false` | no |
| <a name="input_eck_config"></a> [eck\_config](#input\_eck\_config) | Configurations for deploying the Elastic Cloud on Kubernetes (ECK) stack. | `any` | <pre>{<br>  "data_hot_node_count": 1,<br>  "data_hot_node_sc": "gp2",<br>  "data_hot_node_size": "20Gi",<br>  "data_warm_node_count": 1,<br>  "data_warm_node_sc": "gp2",<br>  "data_warm_node_size": "20Gi",<br>  "eck_values": "",<br>  "eckpassword": "",<br>  "eckuser": "elastic",<br>  "hostname": "",<br>  "kibana_node_count": 1,<br>  "master_node_count": 3,<br>  "master_node_sc": "gp2",<br>  "master_node_size": "10Gi",<br>  "namespace": "elastic-system",<br>  "operator_values": ""<br>}</pre> | no |
| <a name="input_eck_version"></a> [eck\_version](#input\_eck\_version) | Version of ECK to be deployed on Kubernetes. | `string` | `"7.17.3"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster to which the ECK stack should be deployed. | `string` | `""` | no |
| <a name="input_elastalert_config"></a> [elastalert\_config](#input\_elastalert\_config) | Configurations for deploying the Elastalert tool, which is an alerting system for Elasticsearch. | `map(any)` | <pre>{<br>  "elastalert_values": "",<br>  "slack_webhook_url": ""<br>}</pre> | no |
| <a name="input_elastalert_enabled"></a> [elastalert\_enabled](#input\_elastalert\_enabled) | Whether the Elastalert tool should be deployed along with the ECK stack or not. | `bool` | `false` | no |
| <a name="input_elb_bucket_arn"></a> [elb\_bucket\_arn](#input\_elb\_bucket\_arn) | The ARN of the ELB S3 bucket | `string` | `""` | no |
| <a name="input_elb_bucket_prefix"></a> [elb\_bucket\_prefix](#input\_elb\_bucket\_prefix) | The prefix for objects in the ELB S3 bucket | `string` | `""` | no |
| <a name="input_exporter_enabled"></a> [exporter\_enabled](#input\_exporter\_enabled) | Whether the ECK exporter should be deployed along with the ECK stack or not. | `bool` | `true` | no |
| <a name="input_filebeat_role_arn"></a> [filebeat\_role\_arn](#input\_filebeat\_role\_arn) | AWS filebeat role arn for authentication aws modules | `string` | `""` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of Helm chart to be used for deploying the ECK stack. | `string` | `"2.9.0"` | no |
| <a name="input_ingress_nginx_controller_enabled"></a> [ingress\_nginx\_controller\_enabled](#input\_ingress\_nginx\_controller\_enabled) | Enable or disable Ingress Nginx Controller | `bool` | `false` | no |
| <a name="input_mongodb_enabled"></a> [mongodb\_enabled](#input\_mongodb\_enabled) | Whether the mongodb filebeat module should be deployed along with the ECK stack or not. | `bool` | `false` | no |
| <a name="input_mongodb_input_type_key"></a> [mongodb\_input\_type\_key](#input\_mongodb\_input\_type\_key) | The key used to identify the database input type | `string` | `""` | no |
| <a name="input_mongodb_input_type_value"></a> [mongodb\_input\_type\_value](#input\_mongodb\_input\_type\_value) | The value associated with the MongoDB input type | `string` | `""` | no |
| <a name="input_mysql_enabled"></a> [mysql\_enabled](#input\_mysql\_enabled) | Whether the mysql filebeat module should be deployed along with the ECK stack or not. | `bool` | `false` | no |
| <a name="input_mysql_input_type_key"></a> [mysql\_input\_type\_key](#input\_mysql\_input\_type\_key) | The key used to identify the database input type | `string` | `""` | no |
| <a name="input_mysql_input_type_value"></a> [mysql\_input\_type\_value](#input\_mysql\_input\_type\_value) | The value associated with the MySQL input type | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the ECK deployment will be deployed. | `string` | `"elastic-system"` | no |
| <a name="input_postgres_input_type_key"></a> [postgres\_input\_type\_key](#input\_postgres\_input\_type\_key) | The value associated with the Postgres input type | `string` | `""` | no |
| <a name="input_postgres_input_type_value"></a> [postgres\_input\_type\_value](#input\_postgres\_input\_type\_value) | The value associated with the postgres input type | `string` | `""` | no |
| <a name="input_postgresql_enabled"></a> [postgresql\_enabled](#input\_postgresql\_enabled) | Whether the postgresql filebeat module should be deployed along with the ECK stack or not. | `bool` | `false` | no |
| <a name="input_provider_type"></a> [provider\_type](#input\_provider\_type) | Choose what type of provider you want (aws, gcp) | `string` | `""` | no |
| <a name="input_rabbitmq_input_type_key"></a> [rabbitmq\_input\_type\_key](#input\_rabbitmq\_input\_type\_key) | The key used to identify the database input type | `string` | `""` | no |
| <a name="input_rabbitmq_input_type_value"></a> [rabbitmq\_input\_type\_value](#input\_rabbitmq\_input\_type\_value) | The value associated with the RabbitMQ input type | `string` | `""` | no |
| <a name="input_redis_input_type_key"></a> [redis\_input\_type\_key](#input\_redis\_input\_type\_key) | The key used to identify the database input type | `string` | `""` | no |
| <a name="input_redis_input_type_value"></a> [redis\_input\_type\_value](#input\_redis\_input\_type\_value) | The value associated with the Redis input type | `string` | `""` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The s3 bucket role arn for the aws bucket provider | `string` | `""` | no |
| <a name="input_s3access_bucket_arn"></a> [s3access\_bucket\_arn](#input\_s3access\_bucket\_arn) | The ARN of the S3 Access S3 bucket | `string` | `""` | no |
| <a name="input_s3access_bucket_prefix"></a> [s3access\_bucket\_prefix](#input\_s3access\_bucket\_prefix) | The prefix for objects in the S3 Access S3 bucket | `string` | `""` | no |
| <a name="input_vpc_flowlogs_bucket_arn"></a> [vpc\_flowlogs\_bucket\_arn](#input\_vpc\_flowlogs\_bucket\_arn) | The ARN of the VPC Flow Logs S3 bucket | `string` | `""` | no |
| <a name="input_vpc_flowlogs_bucket_prefix"></a> [vpc\_flowlogs\_bucket\_prefix](#input\_vpc\_flowlogs\_bucket\_prefix) | The prefix for objects in the VPC Flow Logs S3 bucket | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eck"></a> [eck](#output\_eck) | ECK\_Info |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/sq-ia/terraform-kubernetes-elastic/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/sq-ia/terraform-kubernetes-elastic).

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
