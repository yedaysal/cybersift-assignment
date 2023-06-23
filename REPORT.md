# CyberSift Assignment Report

## Table of Contents

## Introduction

This report is intended to state the purpose of the project, give brief information about the technology stack that forms the infrastructure, show installation steps, and highlight the results.

Log Management and Analysis are essential for both security and compliance, and also has a crucial importance for cybersecurity. Elastic Stack and Apache NiFi are open-source solutions for collecting, transforming, shipping, storing and visualizing logs.

### Purpose of The Project

The aim of the project is to achieve the following assignment objectives:

1. Setting up the foundation for Elastic Stack and Apache NiFi
2. Performing Elastic Stack and Apache NiFi installations
3. Exploring Apache NiFi capabilities
4. Monitoring the underlying operating system and NiFi

### Technology Stack

This section provides brief information about the technology stack which builds the infrastructure.

#### Amazon EC2

![ec2-logo](./resources/images/ec2-logo.png)

Amazon EC2 is a part of AWS, which allows users to rent virtual computers on which to run their own computer applications. EC2 is used to host the application stack in this project.

#### Amazon S3

![s3-logo](./resources/images/s3-logo.png)

Amazon S3 is a service offered by AWS that provides object storage through a web service interface. S3 is used to store Terraform state files.

#### Amazon VPC

![vpc-logo](./resources/images/vpc-logo.png)

Amazon VPC is an AWS service that provides a virtual private network. VPC is used to create the necessary network infrastructure on AWS Cloud.

#### Ansible

![ansible-logo](./resources/images/ansible-logo.png)

Ansible is a suite of software tools that enables Infrastructure as Code (IaC) and configuration management. Ansible is used to provision the software infrastructure.

##### Apache NiFi

![nifi-logo](./resources/images/nifi-logo.png)

Apache NiFi is a tool that is designed to automate the flow of data between software systems. NiFi is used to receive, transform and send logs.

#### Docker Compose

![compose-logo](./resources/images/compose-logo.png)

Docker Compose is a tool for defining and running single- and multi-container applications. Compose is used to define and bring up different containerized application stacks in the software infrastructure.

#### Docker Engine

![docker-logo](./resources/images/docker-logo.png)

Docker Engine is an open source containerization technology for building and containerizing applications. Docker Engine is the underlying technology for the containerized applications in the software stack.

#### Elasticsearch

![es-logo](./resources/images/es-logo.png)

Elasticsearch is a distributed analytics engine for all types of data. It is used to store data structured in Apache NiFi.

#### Filebeat

![filebeat-logo](./resources/images/filebeat-logo.png)

Filebeat is an agent that ships log data to to the specified location. Filebeat is used to ship logs to Apache NiFi.

#### Grafana

![grafana-logo](./resources/images/grafana-logo.png)

Grafana is an open source analytics and interactive visualization web application. It is used to visualize operating system metrics received from InfluxDB.

#### InfluxDB

![influxdb-logo](./resources/images/influxdb-logo.png)

InfluxDB is an open source time series database. InfluxDB is used to store host metrics collected by Telegraf agent.

#### Kibana

![kibana-logo](./resources/images/kibana-logo.png)

Kibana is a data virtualization web application for Elasticsearch. It is used to virtualize data stored in Elasticsearch.

#### Telegraf

![telegraf-logo](./resources/images/telegraf-logo.png)

Telegraf is a server-based agent for collecting and sending all metrics and events from systems. It is used for collecting underlying operating system metrics and sending them to InfluxDB.

#### Terraform

![terraform-logo](./resources/images/terraform-logo.png)

Terraform is an open source Infrastructure as Code (IaC) software tool for defining, creating, changing and versioning cloud and on-prem resources. It is used to build the necessary computing environment on AWS Cloud.

## Installation

This section explains the installation and configuration steps.

### Controller Server Prerequisite Check and Configuration

After setting up a virtual machine to provision it as the controller server following the *Controller Server Hardware Requirements* table in the [*Environment Setup*](./infrastructure/terraform/aws/README.md) document, the below actions have been performed:

Ubuntu Server 20.04 LTS has been installed to the VM.

Made sure the controller server has access to the internet:

```console
cybersift@controller:~$ ping -c 4 www.google.com
PING www.google.com (172.217.17.100) 56(84) bytes of data.
64 bytes from sof02s47-in-f4.1e100.net (172.217.17.100): icmp_seq=1 ttl=115 time=22.2 ms
64 bytes from sof02s47-in-f4.1e100.net (172.217.17.100): icmp_seq=2 ttl=115 time=22.2 ms
64 bytes from sof02s47-in-f4.1e100.net (172.217.17.100): icmp_seq=3 ttl=115 time=22.1 ms
64 bytes from sof02s47-in-f4.1e100.net (172.217.17.100): icmp_seq=4 ttl=115 time=21.9 ms
```

Made sure the prerequisite software have installed on the controller server:

```console
cybersift@controller:~$ apt list --installed | grep -E "ansible/|terraform/|git/|openssh-server/|openssh-client/|python3/"

ansible/focal,now 2.9.6+dfsg-1 all [installed]
git/focal-updates,focal-security,now 1:2.25.1-1ubuntu3.11 amd64 [installed,automatic]
openssh-client/focal-updates,now 1:8.2p1-4ubuntu0.7 amd64 [installed,automatic]
openssh-server/focal-updates,now 1:8.2p1-4ubuntu0.7 amd64 [installed]
python3/focal,now 3.8.2-0ubuntu2 amd64 [installed,automatic]
terraform/focal,now 1.5.1-1 amd64 [installed]
```

A passwordless SSH key pair has been created on the controller node:

```console
cybersift@controller:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/cybersift/.ssh/id_rsa):
Created directory '/home/cybersift/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/cybersift/.ssh/id_rsa
Your public key has been saved in /home/cybersift/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:ZCmujNmPcHVw3VBRDvQDH7yGkPTcS5XGwkkC6GgaJZ0 cybersift@controller
The key's randomart image is:
+---[RSA 3072]----+
|    . . .o+=O== o|
|   . E . oo=.@.* |
|    o = = ..+.X. |
|   . + B    ..oo |
|    + o S    ..  |
|   * o .         |
|  + =            |
|   o o           |
|    . .          |
+----[SHA256]-----+
```

The Access key and Secret access key information have been retrieved from AWS Management Console, the `~/.aws` directory, `~/.aws/config` and `~/.aws/credentials` files have been created, and the necessary data have been added to the files:

```console
cybersift@controller:~$ cat ~/.aws/config
[profile cybersift]
region = eu-central-1
output = json
cybersift@controller:~$ cat ~/.aws/credentials
[cybersift]
aws_access_key_id = AKIAU5WXGLI3YVIPF7VV
aws_secret_access_key = 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
```

The [cybersift](https://github.com/yedaysal/cybersift) repository has been cloned the current user's home directory, the `~/cybersift/infrastructure/terraform/aws/s3` has been entered, the AWS profile `cybersift` has been added to the `variables.tf` file, *s3* Terraform module has been initialized and an S3 bucket named `cybersift-terraform-state` has been created on AWS:

```console
cybersift@controller:~$ cd ; git clone https://github.com/yedaysal/cybersift.git
Cloning into 'cybersift'...
...
```

```console
cybersift@controller:~$ cd ~/cybersift/infrastructure/terraform/aws/s3
cybersift@controller:~/cybersift/infrastructure/terraform/aws/s3$ vim variables.tf
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/s3$ terraform init

Initializing the backend...

...

Terraform has been successfully initialized!

...
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/s3$ terraform plan

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.cybersift will be created
  + resource "aws_s3_bucket" "cybersift" {
      + acceleration_status         = (known after apply)
...

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────

...
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/s3$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.cybersift will be created
  + resource "aws_s3_bucket" "cybersift" {
      + acceleration_status         = (known after apply)
...

Plan: 1 to add, 0 to change, 0 to destroy.
aws_s3_bucket.cybersift: Creating...
aws_s3_bucket.cybersift: Creation complete after 2s [id=cybersift-terraform-state]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

### Application Server Installation and Prerequisite Check

The `~/cybersift/infrastructure/terraform/aws/ec2` has been entered, the AWS profile `cybersift` has been added to both `variables.tf` and `backend.tf` files, public SSH key of the current user has been added to the `variables.tf`file also, *ec2* Terraform module has been initialized and an EC2 instance named `cybersift` (the application server) has been created on AWS:

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/s3$ cd ~/cybersift/infra                          structure/terraform/aws/ec2
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ vim variables.tf
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ vim backend.tf
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ terraform init

Initializing the backend...

...

Terraform has been successfully initialized!

...
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ terraform plan
...

Plan: 9 to add, 0 to change, 0 to destroy.

...
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ terraform apply -au                          to-approve
data.aws_ami.ubuntu: Reading...
data.aws_ami.ubuntu: Read complete after 0s [id=ami-09a13963819e32919]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_default_route_table.cybersift will be created
  + resource "aws_default_route_table" "cybersift" {
      + arn                    = (known after apply)

...

aws_key_pair.cybersift: Creating...
aws_vpc.cybersift: Creating...
aws_key_pair.cybersift: Creation complete after 0s [id=cybersift-pub-key]
aws_vpc.cybersift: Still creating... [10s elapsed]
aws_vpc.cybersift: Creation complete after 12s [id=vpc-0809464745659e6a0]
aws_internet_gateway.cybersift: Creating...
aws_subnet.cybersift: Creating...
aws_default_security_group.cybersift: Creating...
aws_internet_gateway.cybersift: Creation complete after 0s [id=igw-01cb5c26d96a93ac2]
aws_default_route_table.cybersift: Creating...
aws_subnet.cybersift: Creation complete after 0s [id=subnet-06a89d902cba39d07]
aws_default_route_table.cybersift: Creation complete after 1s [id=rtb-00902d9d0409cd45                          d]
aws_default_security_group.cybersift: Creation complete after 2s [id=sg-0cd67c4b2b077f                          53c]
aws_network_interface.cybersift: Creating...
aws_network_interface.cybersift: Creation complete after 0s [id=eni-0010ab3a2c3718514]
aws_instance.cybersift: Creating...
aws_instance.cybersift: Still creating... [10s elapsed]
aws_instance.cybersift: Still creating... [20s elapsed]
aws_instance.cybersift: Still creating... [30s elapsed]
aws_instance.cybersift: Still creating... [40s elapsed]
aws_instance.cybersift: Still creating... [50s elapsed]
aws_instance.cybersift: Creation complete after 53s [id=i-0f6c1707fc4c94ed0]
aws_eip.cybersift: Creating...
aws_eip.cybersift: Creation complete after 1s [id=eipalloc-0b565857ff447e36d]

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

aws_ami_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230616"
eip_id = "eipalloc-0b565857ff447e36d"
iface_id = "eni-0010ab3a2c3718514"
igw_id = "igw-01cb5c26d96a93ac2"
instance_id = "i-0f6c1707fc4c94ed0"
instance_public_dns_hostname = "ec2-3-124-45-204.eu-central-1.compute.amazonaws.com"
instance_public_ip = "3.124.45.204"
route_table_id = "rtb-00902d9d0409cd45d"
security_group_id = "sg-0cd67c4b2b077f53c"
subnet_id = "subnet-06a89d902cba39d07"
vpc_id = "vpc-0809464745659e6a0"
```

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ ssh ubuntu@ec2-3-124-45-204.eu-central-1.compute.amazonaws.com

...

Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1038-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Jun 23 09:06:50 UTC 2023

  System load:  0.0               Processes:             107
  Usage of /:   3.3% of 48.27GB   Users logged in:       0
  Memory usage: 5%                IPv4 address for eth0: 172.16.10.100
  Swap usage:   0%

...

ubuntu@ip-172-16-10-100:~$
```

The application server has been connected to and made sure the prerequisite software have installed on the controller server:

```console
ubuntu@ip-172-16-10-100:~$ apt list --installed | grep -E "openssh-server/|openssh-client/|python3/"

openssh-client/focal-updates,now 1:8.2p1-4ubuntu0.7 amd64 [installed,automatic]
openssh-server/focal-updates,now 1:8.2p1-4ubuntu0.7 amd64 [installed]
python3/focal,now 3.8.2-0ubuntu2 amd64 [installed,automatic]
```

<br>

After this point, the controller server has become ready for software infrastructure setup.
