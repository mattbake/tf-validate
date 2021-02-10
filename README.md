# Intersight Terraform Service Samples
## What is this?
This repository contains a working set of samples for the Intersight Terraform Service.

## Why should I care?
As infrastructure deployments become more complex, manually instantiation through a GUI or even a CLI does not scale.  Infrastructure as Code (IaC) offers an alternative that can be parametrized and version controlled, opening the door to a larger DevOps world

Consider the following 1 minute video (click image to play on YouTube):

[![Why Should I Care](./media/Why_Should_I_Care.png "Why Should I Care")](https://www.youtube.com/watch?v=l38Mf3L9Qo8)

The Intersight Terraform Service brings the Terraform de facto industry standard to Intersight and the entire Cisco ecosystem.

## What should I do next?
This repository contains a number of samples to get you started.  Clone it, [install Terraform](https://www.terraform.io/downloads.html) and slect a link below to work through a specific sample:

* [Deploy a VM in a network on AWS](./aws/vm/README.md)
    - [Integrating an AWS VM Deployment with Terraform Cloud](./aws/vm/TerraformCloud.md)
* [Deploy a VM in a network on GCP](./gcp/vm/README.md)
* [Deploy a VM in a network on Azure](./azure/vm/README.md)
* [Deploy a VM in a network on VMware](./vmware/vm/README.md)
* [Launch a K8s cluster on AWS](./aws/k8s/README.md)
* [Launch a K8s cluster on GCP](./gcp/k8s/README.md)
* [Launch a K8s cluster on Azure](./azure/k8s/README.md)
* Launch a K8s cluster on IKS (coming soon)


## References
* [Get Started - AWS](https://learn.hashicorp.com/collections/terraform/aws-get-started)
* [Get Started - Google Cloud](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
* [Get Started - Azure](https://learn.hashicorp.com/collections/terraform/azure-get-started)
* [Provision an EKS Cluster (AWS)](https://learn.hashicorp.com/tutorials/terraform/eks)
* [Provision a GKE cluster (Google)](https://learn.hashicorp.com/tutorials/terraform/gke)
* [Provision an AKS Cluster (Azure)](https://learn.hashicorp.com/tutorials/terraform/aks)