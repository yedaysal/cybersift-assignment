# Environment Setup

This document:

- Provides basic information about Terraform
- Explains the Terraform modules created to build the environment
- Provides environment requirements information
- Guidelines to perform environment setup

## Table of Contents

- [The Project's Environment Provisioner: Terraform](#the-projects-environment-provisioner-terraform)
  - [What is Terraform?](#what-is-terraform)
  - [Terraform Modules Created for The Project](#terraform-modules-created-for-the-project)
- [Environment Requirements](#environment-requirements)
- [Setup](#setup)
  - [AWS Configuration](#aws-configuration)
  - [Amazon S3 Bucket Setup](#amazon-s3-bucket-setup)
  - [Amazon EC2 and VPC Resource Setup](#amazon-ec2-and-vpc-resource-setup)
- [Resources](#reosurces)

## The Project's Environment Provisioner: Terraform

### What is Terraform?

**Terraform** is a tool that lets you define, create, change and version cloud and on-prem resources safely and efficiently. For more information, visit [terraform.io](https://www.terraform.io/).

Terraform is used in this project to define the environment infrastructure as code, and create, change, version it.

### Terraform Modules Created for The Project

There are two Terraform modules to setup necessary environment, **s3** and **ec2**. *s3* module creates the Amazon S3 bucket which stores the *ec2* module's Terraform state, and the *ec2* module provisions the required VPC and EC2 resources.

## Environment Requirements

In order to set up a healthy computing environment, 2 virtual machines (**Controller Server** and **Application Server**) are needed:

**Table-1** *Controller Server Hardware Requirements*

| Item | Requirement |
| --- | --- |
| CPU | 1 cores or more |
| Memory | 2 GB or more |
| Disk Space | 20 GB or more |

<br>

**Table-2** *Application Server Hardware Requirements*

| Item | Requirement |
| --- | --- |
| CPU | 2 cores or more |
| Memory | 4 GB or more |
| Disk Space | 50 GB or more |

<br>

**Table-3** *Controller Server Software Requirements*

| Item | Requirement |
| --- | --- |
| Operating System | Ubuntu |
| OS Image (AMI) | Ubuntu Server 20.04 LTS or later |
| Base Environment | Minimal Install |
| [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) | Latest Stable core Version |
| [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) | Latest Stable Version |
| [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) | Latest Stable Version |
| [Python 3](https://www.python.org/downloads/) | Latest Stable Version |
| [OpenSSH](https://www.openssh.com/) (client and server) | Latest Stable Version |

<br>

**Table-4** *Application Server Software Requirements*

| Item | Requirement |
| --- | --- |
| Operating System | Ubuntu |
| OS Image (AMI) | Ubuntu Server 20.04 LTS or later |
| Base Environment | Minimal Install |
| [Python 3](https://www.python.org/downloads/) | Latest Stable Version |
| [OpenSSH](https://www.openssh.com/) (client and server) | Latest Stable Version |

Before proceeding to next section:

- Set up a controller server with the specifications in Table-1, and ensure that  all software listed in Table-3 are installed.
- Make sure that the controller server has access to the Internet.
- On the controller node, create a passwordless ssh key pair.

## Setup

### AWS Configuration

In order Terraform to create resources on AWS, an AWS configuration is required. Follow the steps below to create an configuration:

**On a web browser:**

1. Go to [AWS Management Console](https://aws.amazon.com/console/) and login.
2. On the console go to **IAM** service.
3. On the menu, go to **Access management -> Users**.
4. Find and click on your user account that you used to login.
5. Go to **Security credentials -> Access keys** section to create an access key pair and click on **Create access key**.
6. On the opening page, select **Command Line Interface (CLI)** option and click on **Next** button.
7. Describe the purpose of the access key (optional) and click on **Create access key** button on the opening page.
8. Save the **Access key** and **Secret access key** information to use in AWS CLI config.

**On the controller server:**

9. Run `mkdir ~/.aws` command to create AWS configuration directory in the current user's home directory.
10. Execute `touch ~/.aws/config ~/.aws/credentials` command to create two files to put configuration and credentials (access key and secret access key) into.
11. Open the `~/.aws/config` file with any text editor and put the following information into it:

```
[profile USER_PROFILE_NAME]
region = eu-central-1
output = json
```

12. Open the `~/.aws/credentials` file with any text editor and put the following information into it:

```
[USER_PROFILE_NAME]
aws_access_key_id = ACCESS_KEY
aws_secret_access_key = SECRET_ACCESS_KEY
```

### Amazon S3 Bucket Setup

To create an Amazon S3 bucket, follow the steps below on the **controller server**:

1. Clone this repository with `git clone` command into the current user's home directory:

```console
cd ; git clone https://github.com/yedaysal/cybersift.git
```

2. cd into the `cybersift/infrastructure/terraform/aws/s3`:

```console
cd ~/cybersift/infrastructure/terraform/aws/s3
```

3. Change the `profile` variable's value to the profile name defined in the [AWS Configuration](#aws-configuration) section in the `variables.tf` file.

4. Initialize the current working directory, which contains the Terraform configuration files, with `terraform init`command:

```console
terraform init
```

5. Run `terraform plan` command to  preview the changes that Terraform plans to make to your infrastructure:

```console
terraform plan
```

6. To execute the actions proposed in the Terraform plan, run the `terraform apply`command and provide `yes` input when prompted (or use `terraform apply -auto-approve` instead of `terraform apply`):

```console
terraform apply
```

<br>

If there is no error in the `terraform apply` output, that means the requested bucket is created.

<br>

> **Note**
> To remove created resources, use `terraform destroy` command.
> **Warning**
> Be careful while using the `terraform destroy` command since it destroys all infrastructure created.

### Amazon EC2 and VPC Resource Setup

To create the necessary network and virtualization infrastructure on Amazon EC2 and VPC services, follow the steps below on the **controller server**:

1. cd into the `cybersift/infrastructure/terraform/aws/ec2` directory:

```console
cd ~/cybersift/infrastructure/terraform/aws/ec2
```

2. Change the `profile` variable's value to the profile name defined in the [AWS Configuration](#aws-configuration) section in the `variables.tf` file.
3. Change the `public_key` variable's value to current user's public SSH key files (`id_rsa.pub`) content in the `variables.tf` file to place the current user's public ssh key to the `authorized_keys` file of default user (**ubuntu**) of the application server to be created. This will allow the current user to SSH into application server without passowrd. 
4. Change the `profile` attribute's value to the profile name defined in the [AWS Configuration](#aws-configuration) section in the `backend.tf` file.
5. Initialize the current working directory, which contains the Terraform configuration files, with `terraform init`command:

```console
terraform init
```

6. Run `terraform plan` command to  preview the changes that Terraform plans to make to your infrastructure:

```console
terraform plan
```

7. To execute the actions proposed in the Terraform plan, run the `terraform apply`command and provide `yes` input when prompted (or use `terraform apply -auto-approve` instead of `terraform apply`):

```console
terraform apply
```

8. Save the public DNS hostname of the application server (value of the `instance_public_dns_hostname` variable) in the `terraform apply` command output to use it in the Ansible inventory file later for [*Software Infrastructure Setup*](../../ansible/README.md) process.

9. If there is no error in the `terraform apply` output, the application server should be up and ready, and accessible via SSH without providing any password:

```console
ssh ubuntu@APP_SRV_PUB_DNS_HOSTNAME
```

<br>

> **Note**
> To remove created resources, use `terraform destroy` command.
> **Warning**
> Be careful while using the `terraform destroy` command since it destroys all infrastructure created.

After this point, it can be proceeded with the [*Software Infrastructure Setup*](../../ansible/README.md).

## Resources
