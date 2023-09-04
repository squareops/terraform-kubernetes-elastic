## Elastic Cloud Kubernetes
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>

This ECK module is a Kubernetes operator for Elasticsearch and Kibana that simplifies the deployment, management, and scaling of Elasticsearch and Kibana clusters in Kubernetes environments. The ECK module allows you to easily create and configure Elasticsearch and Kibana clusters, and provides customization options such as persistent volume claim templates and storage classes. Additionally, the ECK module provides security features such as encryption and authentication for Elasticsearch and Kibana clusters. With the ECK module, you can manage Elasticsearch and Kibana clusters in a scalable and efficient manner, while also ensuring the security of your data.

## Important Notes:
This module is compatible with EKS version 1.23,1.24,1.25 and 1.26 which is great news for users deploying the module on an EKS cluster running that version. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.

## Supported Versions Table:

| Resources             |  Helm Chart Version                |     K8s supported version                        |  
| :-----:               | :---                               |         :---                                     |
| Elastic-Operator      | **2.7.0**                          |    **1.23**,**1.24**,**1.25**,**1.26**           |
| ECK                   | **7.17.3**                         |    **1.23**,**1.24**,**1.25**,**1.26**           |
| Elastalert2           | **2.9.0**                          |    **1.23**,**1.24**,**1.25**,**1.26**           |


## Usage Example

```hcl
module "eck" {
  source       = "https://github.com/sq-ia/terraform-kubernetes-elastic.git"
  cluster_name = "dev-cluster"
  eck_config = {
    hostname          = "eck.squareops.in"
    eck_values        = ""
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
    elastalert_values = ""
  }
}


```
Refer [examples](https://github.com/sq-ia/terraform-kubernetes-elastic/tree/main/examples/complete) for more details.

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.eck_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [helm_release.eck_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elastalert](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elastic_stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.elasticsearch_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.elastic_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [time_sleep.wait_60_sec](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [kubernetes_secret.eck_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Helm chart to be used for deploying the ECK stack. | `string` | `"2.9.0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster to which the ECK stack should be deployed. | `string` | `""` | no |
| <a name="input_eck_config"></a> [eck\_config](#input\_eck\_config) | Configurations for deploying the Elastic Cloud on Kubernetes (ECK) stack. | `any` | <pre>{<br>  "data_hot_node_count": 1,<br>  "data_hot_node_sc": "gp2",<br>  "data_hot_node_size": "20Gi",<br>  "data_warm_node_count": 1,<br>  "data_warm_node_sc": "gp2",<br>  "data_warm_node_size": "20Gi",<br>  "eck_values": "",<br>  "hostname": "",<br>  "kibana_node_count": 1,<br>  "master_node_count": 3,<br>  "master_node_sc": "gp2",<br>  "master_node_size": "10Gi"<br>}</pre> | no |
| <a name="input_eck_version"></a> [eck\_version](#input\_eck\_version) | Version of ECK to be deployed on Kubernetes. | `string` | `"7.17.3"` | no |
| <a name="input_elastalert_config"></a> [elastalert\_config](#input\_elastalert\_config) | Configurations for deploying the Elastalert tool, which is an alerting system for Elasticsearch. | `map(any)` | <pre>{<br>  "elastalert_values": "",<br>  "slack_webhook_url": ""<br>}</pre> | no |
| <a name="input_elastalert_enabled"></a> [elastalert\_enabled](#input\_elastalert\_enabled) | Whether the Elastalert tool should be deployed along with the ECK stack or not. | `bool` | `false` | no |
| <a name="input_exporter_enabled"></a> [exporter\_enabled](#input\_exporter\_enabled) | Whether the ECK exporter should be deployed along with the ECK stack or not. | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the ECK deployment will be deployed. | `string` | `"elastic-system"` | no |

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
