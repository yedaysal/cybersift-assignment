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

If no error occurs during the `ansible-playbook` command execution, that states the software infrastructure is up and ready.

> **Note**
> `install.yml` playbook provides the execution of all plays in the `plays/` directory from one central point. Alternatively, the plays in the `plays/` directory can be run individually with `ansible-playbook` command regardless of the order of run.

<br>

After the installation 3 important WEB-GUIs become available:

**Table-1** *WEB GUI Information*

| Name | URL | Initial Username | Initial Password |
| --- | --- | --- | --- |
| Kibana UI | [http://APP_SRV_PUB_DNS_HOSTNAME:5601/](http://APP_SRV_PUB_DNS_HOSTNAME:5601/) | elastic | y56#ZRWP8yHsk?ew |
| NiFi UI | [http://APP_SRV_PUB_DNS_HOSTNAME:8081/nifi](http://APP_SRV_PUB_DNS_HOSTNAME:8081/nifi) | - | - |
| Grafana UI | [http://APP_SRV_PUB_DNS_HOSTNAME:3000/](http://APP_SRV_PUB_DNS_HOSTNAME:3000) | admin | ?dPxPzvV%@U6vcks |

## Resources

- [deviantony/docker-elk](https://github.com/deviantony/docker-elk)
- [Apache NiFi: From Syslog to Elasticsearch](https://blog.davidvassallo.me/2018/09/19/apache-nifi-from-syslog-to-elasticsearch/)
- [Apache NiFi Overview](https://nifi.apache.org/docs.html)
- [Relaying Syslog UDP Events with Apache NiFi](https://exceptionfactory.com/posts/2022/09/26/relaying-syslog-udp-events-with-apache-nifi/)
- [Apache NiFi - The request contained an invalid host header](https://stackoverflow.com/questions/48771728/apache-nifi-the-request-contained-an-invalid-host-header)
- [Security Configuration](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#single_user_identity_provider)
- [community.grafana.grafana_datasource module – Manage Grafana datasources](https://docs.ansible.com/ansible/latest/collections/community/grafana/grafana_datasource_module.html)
- [Controlling where tasks run: delegation and local actions](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html)
- [Use a pre-existing network](https://docs.docker.com/compose/networking/#use-a-pre-existing-network)
- [docker_container – manage docker containers
](https://docs.ansible.com/ansible/2.9/modules/docker_container_module.html)
- [Loops](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#loops)
- [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#using-role-dependencies)
- [Install Telegraf](https://docs.influxdata.com/telegraf/v1.21/introduction/installation/)
- [Wait for a couple of minutes to check if an URL is responding](https://stackoverflow.com/questions/72363095/wait-for-a-couple-of-minutes-to-check-if-an-url-is-responding)
- [Shell script - remove first and last quote (") from a variable](https://stackoverflow.com/questions/9733338/shell-script-remove-first-and-last-quote-from-a-variable)
- [Sending Messages to a Remote Syslog Server](https://www.rsyslog.com/sending-messages-to-a-remote-syslog-server/)
- [Configuring Remote Logging using rsyslog in CentOS/RHEL
](https://www.thegeekdiary.com/configuring-remote-logging-using-rsyslog-in-centos-rhel/)
- [How To Send Linux Logs to a Remote Server](https://linuxhint.com/send_linux_logs_remote_server/)
- [How to delete from a text file, all lines that contain a specific string?](https://stackoverflow.com/questions/5410757/how-to-delete-from-a-text-file-all-lines-that-contain-a-specific-string)
- [Set up Telegraf, InfluxDB and Grafana with Docker Compose](https://sweetcode.io/set-up-telegraf-influxdb-and-grafana-with-docker-compose/)
- [Telegraf - system metrics](https://grafana.com/grafana/dashboards/5955-telegraf-system-metrics/)
- [How to Install Grafana TIG stack Ubuntu](https://www.turbogeek.co.uk/grafana-ubuntu-tig-stack/)
- [community.grafana.grafana_dashboard module – Manage Grafana dashboards](https://docs.ansible.com/ansible/latest/collections/community/grafana/grafana_dashboard_module.html)
- [ansible.builtin.stat module – Retrieve file or file system status](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/stat_module.html)
- [Set default umask of 0027 for all Beats-created files](https://github.com/elastic/beats/pull/14119/commits)
- [Nifi SplitJson - how to split json array to individual recods?](https://community.cloudera.com/t5/Support-Questions/Nifi-SplitJson-how-to-split-json-array-to-individual-recods/m-p/210624)
- [Configure the File output](https://www.elastic.co/guide/en/beats/filebeat/current/file-output.html)
- [Shell scripting: -z and -n options with if](https://unix.stackexchange.com/questions/109625/shell-scripting-z-and-n-options-with-if)
- [ansible.builtin.wait_for module – Waits for a condition before continuing](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/wait_for_module.html)
- [docker_network – Manage Docker networks](https://docs.ansible.com/ansible/2.9/modules/docker_network_module.html)
- [How to write a good README for your GitHub project?](https://bulldogjob.com/readme/how-to-write-a-good-readme-for-your-github-project)
- [Readme Best Practices](https://github.com/jehna/readme-best-practices)
- [Ansible (software)](https://en.wikipedia.org/wiki/Ansible_(software))
