# Deploy a VM in a network on Google Cloud

## Purpose
These files should enable the you to deploy a VM and all required elements within GCP. 

## Prerequisites
This sample will deploy resources to create a fresh GCP VM and may incur costs.  There are a few things you need to have configured before you can get started:

* The [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts)
* An project with the right set of APIs enabled (the sample will tell you which you are missing), including [GCE](https://console.developers.google.com/apis/api/compute.googleapis.com/overview) and [GKE](https://console.cloud.google.com/apis/api/container.googleapis.com/overview)

You should also use `gcloud` to add your account in question to the Application Default Credentials (ADC) so that Terraform can reuse the `gcloud` credentials associated with the account.  You can enable this by executing:
```
gcloud auth application-default login
```

## Examining the files
Terraform is smart enough to gather all `.tf` files it finds and evaluates them together, but a typical structure is to have three files `variables.tf`, `output.tf`, and `main.tf`.  Let's walk through the details of each.

### variables.tf
Similar to the previous sample, this file is used to parameterize various aspects of the infrastrcutre to be deployed. In this sample, variables are declared for the project ID, region, zone, and machine type.  These variables can be overwritten at the Terraform command line, using a `terraform.tfvars file`, or through environment variables.  For details, see the [Terraform documentation on Input Variables](https://www.terraform.io/docs/configuration/variables.html).  Be sure to set `project_id` for the project ID in your GCP account, but the others can use their defaults

### output.tf
Terraform can output values from the infrastructure it creates to be used by CI/CD toolchains or other applications.  In this sample, there is one output defined corresponding to the IP address of the created instance.

### main.tf
Most of the functionality in this sample is found in the `main.tf` file.  Terraform extensions are called "providers" and a rich set of them can be found in the [Terraform Registry](https://registry.terraform.io/).  In the `terraform` block of `main.tf`, [the provider created and maintained for Google](https://registry.terraform.io/providers/hashicorp/google/latest/docs) is referenced for download and then configured in the `provider` block, which makes use of three of the variables defined in `variables.tf`

Four `resource` blocks then define the pieces of infrastructure to be instantiated on GCP.  Specifically, a network and an instance.  Note how the different pieces refer to the variables and each other to form a complete deployment.

## Deploying using the example Terraform code

### Terraform Init
Before you can start to use Terraform, you need to initialize the current project.

At the command line, execute:
```
terraform init
```
which should show you the steps Terraform has taken to initialize your project.

Note that this should produce a `.terraform.lock.hcl` file and a `.terraform` folder, which helps Terraform maintain the state of your infrastructure.

### Terraform Plan
Terraform can tell you what it will do before it does it with the `plan` command.

At the command line, execute:
```
terraform plan
```
which should yield a list of items that Terraform will change relative to its current notion of state.  So far in this example, it should show `+` for all the resources since there is nothing in your current state but in the future it might also show `~` for items that will change or `-` for items that will be deleted.

### Terrraform Apply
Applying a plan is done with a separate command, which by default will ask you to confirm the changes.

At the command line, execute:
```
terraform apply
```
That should yield something similar to the `plan` command and When prompted, type `yes`.  Terraform will then give you indicators to its progress before eventually displaying the defined output.  If you check your AWS console, you will find a new VPC, new subnet, new security group, and new instance have all been created exactly as defined by the Terraform scripts.

### Making a Change
Now that some infrastructure has been deployed, let's make a change.  Edit the `machine_type` variable to `g1-small`.

At the command line, execute:
```
terraform plan
```
This should now show you the ripple effect of changed and deleted resources given this variable edit you just made.  In particular, notice that Terraform tells you that the instance must be replaced and that the change forces the replacement.  This is because GCP does not allow an existing VM to have its size changed.  Instead, the existing VM needs to be destroyed and a new one created with the new size.  For other attributes of deployed infrastrcuture, replacement is not necessary.  This varies by provider and specific piece of infrastructure.

Now execute:
```
terraform apply
```
That should yield something similar to the `plan` command and When prompted, type `yes`.  Terraform will then give you indicators to its progress before eventually displaying the defined output.  If you check your GCP console, you will find the VPC, subnet, and security group are as before, but a new instance with the new image has been created.

### Terraform Destroy
Finally, now that you have created and changed infrastructure, it is time to destroy them.  Execute:
```
terraform destroy
```
This will display all the resources that are about to be destroyed.  When prompted, type `yes`.

Terraform will then give you indicators to its progress.  If you check your GCP console, you will find that all the resources created in this sample are now removed.

## Troubleshooting

### Terraform Validate
If, when you perform either your `init` or `plan`, Terraform returns an error it may be down to badly formatted code. Terraform has a built in validator that you can use in order to check your code for errors. This can be run from within the project directory in the following way;

At command line, type
 ```
  terraform validate
 ```

You can also specify exact files, but by default this will review all files within a project. Full details of how to use terraform validate are [here](https://www.terraform.io/docs/commands/validate.html).

### Terraform Refresh
Terraform maintains knowledge of the current infrastructure via its state file and assumes all changes to infrastructure will be performed within Terraform. This is best practice but often changes may occur outwith Terraform (such as from the web UI). If Terraform finds that the infrastructure is not as expected, it will not continue. In order to ensure that Terraform has the most up-to-date knowledge of the infrastructure you can force Terraform to rebuild its state file with the current state using the `terraform refresh` command. 

In situations where there may be configuration drift, this can be a critical tool. It can be performed by running 
```
terraform refresh
``` 

from the command line and it will update the statefile with its findings, but you may also specify a seperate state file if you do not want to overwrite the existing file. Full details of the command can be found [here](https://www.terraform.io/docs/commands/refresh.html).

## Wrapping up and next steps with Terraform Cloud
This concludes the sample to **Deploy a VM in a network on GCP**. 