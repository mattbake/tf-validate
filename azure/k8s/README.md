# Deploying a Kubernetes cluster within Azure using Terraform

## Purpose
These files should enable the user to deploy Kubernetes(K8s) and all required elements within an Azure cloud resource group. It utilizes images freely available within Azure and will include instructions on how to remove the created elements if needed.

## Prerequisites
The examples included here are aimed to help you get started in managing your Azure resources as code. This code and associated documentation will serve as a functional guide to deploy infrastructure using Terraform, but the provided [Terraform documentation](https://www.terraform.io/intro/index.html) will help extend this knowledge. As the progress through the steps later in this document, links will be provided to allow you to learn more about each command. 

The code included in this will require the user to have authenticated in Azure by using the 'az' cli tool available for Azure. These are documented [here](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest), with versions available for Mac, Windows and Linux. The code within this example was tested on both Mac and Linux. 

When utilizing Terraform, the Terraform binary must be installed. This is available from [HashiCorp](https://www.terraform.io/downloads.html) and it will need to be included in your PATH or installed within the local directory for the examples to execute successfully.


## Deploying using the example Terraform code

### Terraform Init
This is the first step when starting any Terraform based deploy and it will initialize the current project. When this happens, Terraform will look at the Terraform code that might be executed and import the required providers, in this case Azure. For this reason, you should be in the same location as your terraform code before performing a `terraform init`. 

At the command line, execute:
```
terraform init
```
which should show you the steps Terraform has taken to initialize your project.

Note that this should produce a `.terraform.lock.hcl` file and a `.terraform` folder, which helps Terraform maintain the state of your infrastructure. These are key files, but they are manged by Terraform and should not be edited or removed. 

You can learn more about terraform init [here](https://www.terraform.io/docs/commands/init.html).

### Terraform Plan
Once a project has been initiated, Terraform can be made to plan the changes to infrastructure with the `terraform plan` command. This command is a great example of the idempotent approach that Terraform has to infrastructure. When run, Terraform will evaluate the desired state from the configuration files, compare it to the current state (as it sees it) and alert to you all changes that will occur. 

It's important to note that no changes will *actually* be made here, this is to let you know what will happen when the Terraform code is applied to the infrastructure. 

To see the changes that will be applied by the local Terraform project, run
```
terraform plan
```
You can learn more about terraform plan [here](https://www.terraform.io/docs/commands/plan.html).

### Terraform Apply
It is this command that will cause Terraform to perform the changes in order to match the deployed infrastructure with the project configuration files.  Ideally this is run after `terraform plan` and as such simply applies the existing change plan from that run, but it can be run in isolation as well and will generate a plan on run. 

At the command line,  run
```
terraform apply
```

The changes will not be applied until you enter `yes` on prompt. Full details of the command can be found [here](https://www.terraform.io/docs/commands/apply.html).


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
