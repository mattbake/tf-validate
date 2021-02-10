# Launch a K8s cluster on GCP
## Purpose
This sample is of medium to hard difficulty and it is highly recommended that you first complete the [Deploy a VM in a network on GCP sample](../vm/README.md) first.

## Prerequisites
This sample will deploy resources to create a fresh GKE cluster and may incur $0.10 per hour costs.  There are a few things you need to have configured before you can get started:

* The [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts)
* An project with the right set of APIs enabled (the sample will tell you which you are missing), including [GCE](https://console.developers.google.com/apis/api/compute.googleapis.com/overview) and [GKE](https://console.cloud.google.com/apis/api/container.googleapis.com/overview)

You should also use `gcloud` to add your account in question to the Application Default Credentials (ADC) so that Terraform can reuse the `gcloud` credentials associated with the account.  You can enable this by executing:
```
gcloud auth application-default login
```
## Examining the files
Terraform is smart enough to gather all .tf files it finds and evaluates them together, but a typical structure is to have three files `variables.tf`, `output.tf`, and `main.tf`.  Unlike the prior sample, this one can take up to 15 minutes to fully deploy, so you may want to run through the init/plan/apply stages and come back to read the file details while the infrastructure is being provisioned.

### variables.tf
Similar to the previous sample, this file is used to parameterize various aspects of the infrastrcutre to be deployed. In this sample, variables are declared for the project ID and region.  These variables can be overwritten at the Terraform command line, using a `terraform.tfvars file`, or through environment variables.  For details, see the [Terraform documentation on Input Variables](https://www.terraform.io/docs/configuration/variables.html).

### output.tf
In this sample, the outputs serve the purpose of being inputs for using the AWS CLI to configure `kubectl` correctly.

### main.tf
The buik of the Terraform configuation is in this file and it is far more complex than the previous sample given the scope of what is needed to deploy a K8s cluster.  The main part of the deployment is a set of GKE worker nodes.

## Deploying using the example Terraform code

### Terraform Init
This sample uses quite a few more modules than the previous one, all of which need to be downloaded as part of the initilization process.  Execute the following:

```
terraform init
```
This installs the dependent providers and modules needed for the sample.

### Terraform Plan and Apply
Next, execute:
```
terraform plan
```
This will show you all of the resources that will be created and validates their configurations.  Then, execute:
```
terraform apply
```
That should yield something similar to the `plan` command and When prompted, type `yes`.  Terraform will then give you indicators to its progress before eventually displaying the defined output.  This is the point at which if you need to enable certain APIs, you will receive an error message and a link to help you do so before trying again.  If you check your GCP console, you will find all of the new pieces of infrastructure created exactly as defined by the Terraform scripts.  

The `gcloud` CLI can configure `kubectl` based on data it can get from the new K8s cluster.  Notice how the two output items from the successful `apply` step were `region` and `kubernetes_cluster_name`. Use them as follows:

```
gcloud container clusters get-credentials <kubernetes_cluster_name> --region <region>
```
Then confirm you can communicate with the cluster using `kubectl`:
```
kubectl cluster-info 
```

### Terraform Destroy
Finally, now that you have created and changed infrastructure, it is time to destroy them.  Execute:
```
terraform destroy
```
This will display all the resources that are about to be destroyed.  When prompted, type `yes`.

Terraform will then give you indicators to its progress.  If you check your GCP console, you will find that all the resources created in this sample are now removed.

## Wrapping up
You might try this full example multiple times, changing the number and instance type sizes of the VMs.  This would simulate different cluster needs such as development, staging, and production while keeping the core configuration of the cluster identical.