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

After this point, the controller server has become ready for software infrastructure setup on the application server.

### Application Server Software Infrastructure Installation

To install the application stacks on the application server the following actions have been performed on the controller server:

The `~/cybersift/infrastructure/ansible` directory has been entered.

```console
cybersift@controller:~/cybersift/infrastructure/terraform/aws/ec2$ cd ~/cybersift/infrastructure/ansible
cybersift@controller:~/cybersift/infrastructure/ansible$
```

A directory named `gitignore` has been created.

```console
cybersift@controller:~/cybersift/infrastructure/ansible$ mkdir gitignore
```

The Ansible Vault password file `VAULT_PASS` has been created in the `gitignore` directory and the initial password `y4*7nLXb!2z&^Vd9` has been added to it.

```console
cybersift@controller:~/cybersift/infrastructure/ansible$ echo 'y4*7nLXb!2z&^Vd9' > gitignore/VAULT_PASS
```

The `APP_SRV_PUB_DNS_HOSTNAME` entry in the `inventory.ini` file has been changed to the application server's public DNS hostname `ubuntu@ec2-3-124-45-204.eu-central-1.compute.amazonaws.com`.

```console
cybersift@controller:~/cybersift/infrastructure/ansible$ cat inventory.ini
# Hosts to run the docker role on
[docker]
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com

# Hosts to run the docker_elastic role on
[docker_elastic]
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com

# Hosts to run the docker_monitoring role on
[docker_monitoring]
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com

# Hosts to run the docker_nifi role on
[docker_nifi]
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com

# Hosts to run the filebeat role on
[filebeat]
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com

# Hosts to run the telegraf role on
[telegraf]
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com
```

It has been validated that all the hosts (currently only the application server) in the `inventory.ini` file are accessible and manageable by Ansible.

```console
cybersift@controller:~/cybersift/infrastructure/ansible$ ansible all -m ping
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

It has been made sure that the working directory is `~/cybersift/infrastructure/ansible`.

```console
cybersift@controller:~/cybersift/infrastructure/ansible$ pwd
/home/cybersift/cybersift/infrastructure/ansible
```

The `ansible-playbook install.yml` command has been executed to start installation process.

```console
cybersift@controller:~/cybersift/infrastructure/ansible$ ansible-playbook install.yml

PLAY [Ensure docker_elastic role is installed] *****************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure apt package index is updated] ************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure required packages for apt are installed] *************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure python3-pip is installed] ****************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure python docker and docker-compose modules are installed] **********************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure official Docker GPG key is added] ********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Print Docker apt repository entry] **************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure Docker apt repo is configured] ***********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure docker and docker-compose are installed] *************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure user ubuntu is added to docker group] ****************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure docker_elastic network is created] *******************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_elastic : Ensure stack directory (docker-elk) exists] *********************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_elastic : Ensure stack compose file exists] *******************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_elastic : Ensure stack compose env file exists] ***************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_elastic : Ensure docker-elk/setup/entrypoint.sh file is executable] *******************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_elastic : Ensure the stack is up] *****************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_elastic : Ensure Kibana UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:5601/) is available] ***
FAILED - RETRYING: Ensure Kibana UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:5601/) is available (12 retries left).
FAILED - RETRYING: Ensure Kibana UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:5601/) is available (11 retries left).
FAILED - RETRYING: Ensure Kibana UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:5601/) is available (10 retries left).
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

PLAY [Ensure docker_nifi role is installed] ********************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure apt package index is updated] ************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure required packages for apt are installed] *************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure python3-pip is installed] ****************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure python docker and docker-compose modules are installed] **********************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure official Docker GPG key is added] ********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Print Docker apt repository entry] **************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure Docker apt repo is configured] ***********************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure docker and docker-compose are installed] *************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure user ubuntu is added to docker group] ****************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure docker_elastic network is created] *******************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_nifi : Ensure /opt/cybersift/docker_nifi directory exists] ****************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_nifi : Ensure stack compose file exists] **********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_nifi : Ensure the stack is up] ********************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_nifi : Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available] ***
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (24 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (23 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (22 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (21 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (20 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (19 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (18 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (17 retries left).
FAILED - RETRYING: Ensure NiFi UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi) is available (16 retries left).
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_nifi : Ensure rsyslog is configured to send logs to NiFi] *****************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

RUNNING HANDLER [docker_nifi : Restart rsyslog.service] ********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

PLAY [Ensure filebeat role is installed] ***********************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure elastic.co apt key is present] *********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure elastic.co filebeat repository is configured] ******************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure filebeat package is installed] *********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure filebeat.yml is present] ***************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure filebeat service is enabled and started] ***********************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure filebeat output directory exists and is accessible] ************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [filebeat : Ensure "* * * * * chmod 604 /tmp/filebeat/*" cron entry is present] ***************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

RUNNING HANDLER [filebeat : Restart filebeat.service] **********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

PLAY [Ensure docker_monitoring role is installed] **************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure apt package index is updated] ************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure required packages for apt are installed] *************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure python3-pip is installed] ****************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure python docker and docker-compose modules are installed] **********************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure official Docker GPG key is added] ********************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Print Docker apt repository entry] **************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure Docker apt repo is configured] ***********************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure docker and docker-compose are installed] *************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure user ubuntu is added to docker group] ****************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker : Ensure docker_elastic network is created] *******************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure /opt/cybersift/docker_monitoring directory exists] ****************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure stack compose file exists] ****************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure the stack is up] **************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure Grafana UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:3000/) is available] ***
FAILED - RETRYING: Ensure Grafana UI (http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:3000/) is available (12 retries left).
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure Grafana admin user password is changed] ***************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Check if Grafana InfluxDB datasource exists] *****************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure Grafana InfluxDB datasource is added] *****************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [docker_monitoring : Ensure 'Telegraf - system metrics' dashboard exists] *********************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

PLAY [Ensure telegraf role is installed] ***********************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [telegraf : Ensure Telegraf repository is installed] ******************************************************
[WARNING]: Consider using the get_url or uri module rather than running 'wget'.  If you need to use command
because get_url or uri is insufficient you can add 'warn: false' to this command task or set
'command_warnings=False' in ansible.cfg to get rid of this message.
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [telegraf : Ensure apt cache is updated] ******************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [telegraf : Ensure Telegraf is installed] *****************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [telegraf : Ensure telegraf.conf exists] ******************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

TASK [telegraf : Ensure Telegraf service is enabled and started] ***********************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

RUNNING HANDLER [telegraf : Restart telegraf] ******************************************************************
changed: [ec2-3-124-45-204.eu-central-1.compute.amazonaws.com]

PLAY RECAP *****************************************************************************************************
ec2-3-124-45-204.eu-central-1.compute.amazonaws.com : ok=69   changed=42   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```

<br>

After the `ansible-playbook` command execution, the software infrastructure setup has been completed successfully and the Kibana, NiFi and Grafana UIs have been become accessible via URLs below:

- Kibana UI: [http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:5601/](http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:5601/)

![kibana-ui](./resources/screenshots/kibana-ui.png)

<p align="center">
  <strong>Kibana UI</strong>
</p>

- NiFi UI: [http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi](http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:8081/nifi)

![nifi-ui](./resources/screenshots/nifi-ui.png)

<p align="center">
  <strong>NiFi UI</strong>
</p>

- Grafana UI: [http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:3000/](http://ec2-3-124-45-204.eu-central-1.compute.amazonaws.com:3000/)

![grafana-ui](./resources/screenshots/grafana-ui.png)

<p align="center">
  <strong>Grafana UI</strong>
</p>

## Building Nifi Pipelines

NiFi represents the data moving through the system as **FlowFile**. FlowFiles are processed in NiFi units called FlowFile Processor. NiFi pipelines are the combination of FlowFile Processors and can be used to perform a certain task, for example, collecting syslog messages, transforming and sending them to Elasticsearch. Two simple NiFi pipelines have been created in this section:

### Building Syslog Pipeline

After being connected to the NiFi UI, the following operations have been performed to build a simple syslog pipeline:

#### ListenSyslog Processor Configuration

The ListenSyslog processor, which listens for Syslog messages being sent to a given port over TCP or UDP, has been added to the initial canvas and configured to listen on UDP port 10514 since the UDP port 514 is reserved for operating system. Also, rsyslog is configured to send logs to this port.

![ListenSyslog-Scheduling](./resources/screenshots/ListenSyslog-Scheduling.png)

<p align="center">
  <strong>ListenSyslog Scheduling</strong>
</p>

<br>

![ListenSyslog-Properties](./resources/screenshots/ListenSyslog-Properties.png)

<p align="center">
  <strong>ListenSyslog Properties</strong>
</p>

<br>

![ListenSyslog-Relationships](./resources/screenshots/ListenSyslog-Relationships.png)

<p align="center">
  <strong>ListenSyslog Relationships</strong>
</p>

After the configuration, the ListenSyslog processor has been started and the syslog data has been started flowing:

![ListenSyslog-Started](./resources/screenshots/ListenSyslog-Started.png)

<p align="center">
  <strong>ListenSyslog Started</strong>
</p>

#### ConvertRecord Processor Configuration

The ConvertRecord processor converts data from one format to another using configured Record Reader and Record Write Controller Services. It has been configured to convert incoming syslog messages to JSON format.

![ConvertRecord-Scheduling](./resources/screenshots/ConvertRecord-Scheduling.png)

<p align="center">
  <strong>ConvertRecord Scheduling</strong>
</p>

<br>

For ConvertRecord processor to be able to read syslog messages and write them in JSON format, SyslogReader Record Reader service and JsonRecordSetWriter Record Writer service have been created and enabled with default settings, and configured for ConvertRecord processor:

![ConvertRecord-Properties](./resources/screenshots/ConvertRecord-Properties.png)

<p align="center">
  <strong>ConvertRecord Properties</strong>
</p>

<br>

<br>

![SyslogReader-and-JsonRecordSetWriter-services](./resources/screenshots/SyslogReader-and-JsonRecordSetWriter-services.png)

<p align="center">
  <strong>SyslogReader and JsonRecordSetWriter Services</strong>
</p>

<br>

![ConvertRecord-Relationships](./resources/screenshots/ConvertRecord-Relationships.png)

<p align="center">
  <strong>ConvertRecord Relationships</strong>
</p>

After configuring the ConvertRecord processor, it has been connected to the ListenSyslog processor with success relationship and started:

![ConvertRecord-Started](./resources/screenshots/ConvertRecord-Started.png)

<p align="center">
  <strong>ConvertRecord Started</strong>
</p>

<br>

After starting the ConvertRecord processor, it has started to receive data from ListenSyslog processor.

#### PutElasticsearchRecord Processor Configuration

As its name suggests, the PutElasticsearchRecord processor puts data to Elasticsearch. It has been used put JSON formatted data received from ConvertRecord processor to the projects Elasticsearch instance.

![PutElasticsearchRecord-Scheduling](./resources/screenshots/PutElasticsearchRecord-Scheduling.png)

<p align="center">
  <strong>PutElasticsearchRecord Scheduling</strong>
</p>

<br>

For PutElasticsearchRecord processor to be able to read JSON data received from ConvertRecord processor, write the data and connect to an Elasticsearch instance:

- A JsonTreeReader service created and enabled with default settings for the PutElasticsearchRecord processor.
- An ElasticSearchClientServiceImpl service created and enabled with the following settings for the PutElasticsearchRecord processor.
- The previously created JsonRecordSetWriter service is configured for the PutElasticsearchRecord processor.

![ElasticSearchClientServiceImpl-Properties](./resources/screenshots/ElasticSearchClientServiceImpl-Properties.png)

<p align="center">
  <strong>ElasticSearchClientServiceImpl Properties</strong>
</p>

<br>

![Controller-Services](./resources/screenshots/Controller-Services.png)

<p align="center">
  <strong>Added JsonTreeReader and ElasticSearchClientServiceImpl Services</strong>
</p>

<br>

![PutElasticsearchRecord-Properties1](./resources/screenshots/PutElasticsearchRecord-Properties1.png)

<p align="center">
  <strong>PutElasticsearchRecord Properties 1</strong>
</p>

<br>

![PutElasticsearchRecord-Properties2](./resources/screenshots/PutElasticsearchRecord-Properties2.png)

<p align="center">
  <strong>PutElasticsearchRecord Properties 2</strong>
</p>

<br>

![PutElasticsearchRecord-Relationships](./resources/screenshots/PutElasticsearchRecord-Relationships.png)

<p align="center">
  <strong>PutElasticsearchRecord Relationships</strong>
</p>

<br>

After configuring the PutElasticsearch processor, it has been connected to the ConvertRecord processor with success and retry relationships and started:

![PutElasticsearchRecord-Started](./resources/screenshots/PutElasticsearchRecord-Started.png)

<p align="center">
  <strong>PutElasticsearchRecord Started</strong>
</p>

<br>

After configuring and starting the PutElasticsearchRecord pipeline, the building simple syslog pipeline objective has been successfully completed. The data has been sent to Elasticsearch viewed on Kibana:

![es-syslog-nifi-index](./resources/screenshots/es-syslog-nifi-index.png)

<p align="center">
  <strong>Elasticsearch syslog-nifi index on Kibana</strong>
</p>

<br>

![syslog-nifi-dataview](./resources/screenshots/syslog-nifi-dataview.png)

<p align="center">
  <strong>Kibana syslog-nifi data view</strong>
</p>

### Building Filebeat Pipeline

Since the `/var/log/messages` file has been replaced with the `/var/log/syslog` file, the filebeat agent on the application server is configured to collect logs from the `/var/log/syslog` and write the output to `/tmp/filebeat` directory. NiFi will be configured to read the files in the `/tmp/filebeat` directory, split filebeat json output files into single json objects, and send data to Elasticsearch.

#### GetFile Processor Configuration

The GetFile processor creates FlowFiles from files in a directory, which have at least read permissions. This processor has been used to read the filebeat output files under the `/tmp/filebeat` directory and create FlowFiles from them.

![GetFile-Scheduling](./resources/screenshots/GetFile-Scheduling.png)

<p align="center">
  <strong>GetFile Scheduling</strong>
</p>

<br>

![GetFile-Properties](./resources/screenshots/GetFile-Properties.png)

<p align="center">
  <strong>GetFile Properties</strong>
</p>

<br>

![GetFile-Relationships](./resources/screenshots/GetFile-Relationships.png)

<p align="center">
  <strong>GetFile Relationships</strong>
</p>

<br>

After the configuration of the GetFile processor, it has been started and the data has started flowing into NiFi:

![GetFile-Started](./resources/screenshots/GetFile-Started.png)

<p align="center">
  <strong>GetFile Started</strong>
</p>

<br>

#### SplitText Processor Configuration

The SplitText processor splits a text file into multiple smaller text files on line boundaries limited by maximum number of lines or total size of fragment. Each output split file will contain no more than the configured number of lines or bytes. It will be used to split filebeat output json files containing multiple json objects into files that contain single json objects.

![SplitText-Scheduling](./resources/screenshots/SplitText-Scheduling.png)

<p align="center">
  <strong>SplitText Scheduling</strong>
</p>

<br>

![SplitText-Properties](./resources/screenshots/SplitText-Properties.png)

<p align="center">
  <strong>SplitText Properties</strong>
</p>

<br>

![SplitText-Relationships](./resources/screenshots/SplitText-Relationships.png)

<p align="center">
  <strong>SplitText Relationships</strong>
</p>

<br>

After configuring the SplitText processor, it has been connected to the GetFile processor with success relationship and started:

![SplitText-Started](./resources/screenshots/SplitText-Started.png)

<p align="center">
  <strong>SplitText Started</strong>
</p>

<br>

#### PutElasticsearchRecord Processor Configuration

A new PutElasticsearchRecord processor has been configured as in the [*Building Syslog Pipeline*](#building-syslog-pipeline) section to send single json objects to the Elasticsearch instance.

After the PutElasticsearchRecord processor has configured, it has been connected to the SplitText processor with splits relationship to only receive split objects and started:

![Filebeat-PutElasticsearchRecord-Started](./resources/screenshots/Filebeat-PutElasticsearchRecord-Started.png)

<p align="center">
  <strong>PutElasticsearchRecord Processor for Filebeat Pipeline Started</strong>
</p>

<br>

After configuring and starting the PutElasticsearchRecord pipeline, the building simple filebeat pipeline objective has been successfully completed. The data has been sent to Elasticsearch viewed on Kibana:

![es-filebeat-nifi-index](./resources/screenshots/es-filebeat-nifi-index.png)

<p align="center">
  <strong>Elasticsearch filebeat-nifi index on Kibana</strong>
</p>

<br>

![filebeat-nifi-dataview](./resources/screenshots/filebeat-nifi-dataview.png)

<p align="center">
  <strong>Kibana filebeat-nifi data view</strong>
</p>

## Monitoring The Application Server

The monitoring of the application server has been provided by Telegraf, InfluxDB and Grafana tools. Ansible *docker_monitoring* role creates an containerized monitoring stack which consists of InfluxDB and Grafana, and then the *telegraf* role installs an telegraf agent to the application server and starts collecting metrics. All configuration and installation operations are performed by Ansible, without any manual intervention:

- Telegraf agent is installed and configured by Ansible to send logs to InfluxDB container.
- InfluxDB container is installed and configured to store metrics received from Telegraf.
- Grafana container is installed and configured to create an InfluxDB datasource and dashboard to show collected system metrics.

![grafana-influxdb-ds](./resources/screenshots/grafana-influxdb-ds.png)

<p align="center">
  <strong>Grafana InfluxDB Datasource Created by Ansible</strong>
</p>

<br>

![grafana-syst-metrics-db](./resources/screenshots/grafana-syst-metrics-db.png)

<p align="center">
  <strong>Grafana Telegraf - System Metrics Dashboard Created by Ansible</strong>
</p>

<br>


## Result

