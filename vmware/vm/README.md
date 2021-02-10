# Deploy a VM in a network on VMWare
## Purpose
These files should enable the you to deploy a VM and all required elements within VMware.

## Prerequisites
There are a few things you need to have configured before you can get started:

* A login to a vSphere client
* A template in that vSphere environment from which a VM can be launched
* DHCP configured in that environment (optional, although highly recommended.)

## Examining the files
Terraform is smart enough to gather all `.tf` files it finds and evaluates them together, but a typical structure is to have three files `variables.tf`, `output.tf`, and `main.tf`.  Let's walk through the details of each.

### variables.tf
As the name implies, this is the file where variables are defined that are used by other aspects of Terraform.  In this sample, variables are declared for the vSphere server, login credentials, and the target data center, data store, resource pool, network and template.  These variables can be overwritten at the Terraform command line, using a `terraform.tfvars file`, or through environment variables.  For details, see the [Terraform documentation on Input Variables](https://www.terraform.io/docs/configuration/variables.html).

### output.tf
Terraform can output values from the infrastructure it creates to be used by CI/CD toolchains or other applications.  In this sample, there is one output defined corresponding to the IP address of the created instance.

### main.tf
Most of the functionality in this sample is found in the `main.tf` file.  Terraform extensions are called "providers" and a rich set of them can be found in the [Terraform Registry](https://registry.terraform.io/).  In the `terraform` block of `main.tf`, [the provider created and maintained by HashiCorp for VMware](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs) is referenced for download and then configured in the `provider` block.

Five `data` blocks refer to items that can be found in your vSphere environment.  Speficially, the datacenter, datastore, resource pool, network, and template.

The `resource` block then defines the VM based on references from the items found in the `data` blocks.

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

### Terraform Apply
Applying a plan is done with a separate command, which by default will ask you to confirm the changes.

At the command line, execute:
```
terraform apply
```
That should yield something similar to the `plan` command and When prompted, type `yes`.  Terraform will then give you indicators to its progress before eventually displaying the defined output.  If you check vSphere, you will find a VM, created exactly as defined by the Terraform scripts.  Notice how the output item from the successful `apply` step is `ip_address`. You can now use this to `ping` the instance.

Note that if you do not have DHCP configured this step will timeout after 7 or more minutes waiting on the VM to obtain an IP address.  You will have a small window of time to manually configure the VM's networking to obtain one as a work around.

### Making a Change
Now that some infrastructure has been deployed, let's make a change.  Edit the `mai.tf` file to change the name of the vm from `terraform-test` to `terraform-example`. 

At the command line, execute:
```
terraform plan
```
This should now show you the ripple effect of changed and deleted resources given this variable edit you just made.  In psome cases, Terraform will tell you that a resource must be replaced given a variable change.  For other attributes of deployed infrastrcuture, replacement is not necessary.  This varies by provider and specific piece of infrastructure.

Now execute:
```
terraform apply
```
That should yield something similar to the `plan` command and When prompted, type `yes`.  Terraform will then give you indicators to its progress before eventually displaying the defined output.  If you check vSphere, you will find the name changed.

### Terraform Destroy
Finally, now that you have created and changed infrastructure, it is time to destroy them.  Execute:
```
terraform destroy
```
This will display all the resources that are about to be destroyed.  When prompted, type `yes`.

Terraform will then give you indicators to its progress.  If you check vSphere, you will find that all the resources created in this sample are now removed.

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