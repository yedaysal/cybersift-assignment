# Software Infrastructure Setup

This document:

- Provides basic information about Ansible
- Explains the Ansible roles created to form the Software Infrastructure
- Guidelines to perform software infrastructure setup

## Table of Contents

- [The Project's Software Infrastructure Provisioner: Ansible](#the-projects-software-infrastructure-provisioner-ansible)
  - [What is Ansible?](#what-is-ansible)
  - [Ansible Roles Created for The Project](#ansible-roles-created-for-the-project)
- [Prerequisites](#prerequisites)

## The Project's Software Infrastructure Provisioner: Ansible

### What is Ansible?

**Ansible** is an open-source suite of software tools that enables software provisioning, configuration management, and application deployment functionality. For more information, visit [Ansible Documentation web page](https://docs.ansible.com/ansible/latest/index.html).

Ansible is used in this project to define the software infrastructure as code, create and change it.

### Ansible Roles Created for The Project

There are 6 roles created in the project to provide reusability and modularity:

- **docker** role provides the necessary Docker infrastructure for containerized applications.
- **docker_elastic** role creates an containerized application stack which consists of Elasticsearch and Kibana.
- **docker_monitoring** role constructs an containerized application stack which contains InfluxDB and Grafana.
- **docker_nifi** role produces a simple containerized application stack which only contains Apachi NiFi.
- **filebeat** role installs and configures an Filebeat agent which collects and ships logs to Apache NiFi.
- **telegraf** role install and configures an Telegraf agent which gathers and sends metric data to InfluxDB.

<br>

> **Note**
> *docker* role is a prerequisite role for all roles starting with *docker_* keyword, which means Ansible will run the *docker* role before each time these roles are run.

## Prerequisites

For a successfully deployed and healthy software infrastructure, the following prerequisites should be met:

- The controller server must have passwordless SSH access to the application server.
- Since Ansible is based on Python, Python 3 must be installed on both servers.
- Ansible must be installed on the controller server.

## Setup

### Initial Configuration

Before running playbooks and beginning software infrastructure setup, an initial configuration for Ansible is required on the **controller server**:

1. cd into the `~/cybersift/infrastructure/ansible` directory:

```console
cd ~/cybersift/infrastructure/ansible
```

2. Create a directory named `gitignore` to put the Ansible Vault password file `VAULT_PASS` into:

```console
mkdir gitignore
```

3. Run the `touch gitignore/VAULT_PASS` command to create the Ansible Vault password file:

```console
touch gitignore/VAULT_PASS
```

4. Put the initial vault password `y4*7nLXb!2z&^Vd9` into the `VAULT_PASS` file.

> **Note**
> The initial vault password applies to all vault files under the `group_vars` directory. To change the vault password to something other than the initial one, use `ansible-vault rekey VAULT_FILE.yml` command for each vault file, and put the new vault password into the `VAULT_PASS` file. 

5. Change the `APP_SRV_PUB_DNS_HOSTNAME` entry in the `inventory.ini` file to the application server's public DNS hostname, which is created during the [*Environment Setup*](../terraform/aws/README.md) process.

6. To validate that all the hosts (currently only the application server) in the `inventory.ini` file are accessible and manageable by Ansible, use the following Ansible ad hoc command:

```console
ansible all -m ping
```

If the command output contains `SUCCESS` keyword, the software infrastructure is ready to be installed.

### Installation

To begin the installation process, follow the steps below on the **controller server** :

1. Make sure the working directory is `~/cybersift/infrastructure/ansible`:

```console
cd ~/cybersift/infrastructure/ansible
```

2. Run the `ansible-playbook` command:

```console
ansible-playbook install.yml
```
