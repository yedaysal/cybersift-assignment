![cybersift-logo](./resources/images/cybersift-logo.png)

# Cybersift Assignment Repository

Repository that contains the code to setup the necessary environment and software infrastructure, guidelines, and assignment report.

## Table of Contents

- [Introduction - The Project's Aim](#introduction---the-projects-aim)
- [Technologies](#technologies)
  - [Environment Technologies](#environment-technologies)
  - [Software Infrastructure Technologies](#software-infrastructure-technologies)
- [Environment and Software Infrastructure Setup](#environment-and-software-infrastructure-setup)
  - [Environment Setup]()
  - [Software Infrastructure Setup]()

## Introduction - The Project's Aim

The goal of the project is to accomplish the following assignment objectives:

1. Install [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html) (and [Kibana](https://www.elastic.co/guide/en/kibana/current/get-started.html)), and install [Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html) on a CentOS or Ubuntu VM.
2. Build a simple NiFi pipeline which accepts syslog on local port UDP 514 and sends it on to Elasticsearch.
3. Use [Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html) and build a simple Nifi pipeline which gathers data from the local `/var/log/messages`, and sends it on to Elasticsearch.
4. Setup or otherwise show how you would monitor the OS and NiFi using [InfluxDB and Telegraf](https://portal.influxdata.com/downloads/).

## Technologies

This section explains the technologies used in the project.

### Environment Technologies

The technologies used to set up the project environment are:

- [Amazon EC2](https://aws.amazon.com/ec2/) for setting up the virtualization infrastructure
- [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) for setting up the network infrastructure
- [Amazon S3](https://aws.amazon.com/s3/) for storing Terraform state
- [Terraform](https://www.terraform.io/) for defining and provisioning the necessary infrastructure as code
- [Ubuntu Server](https://ubuntu.com/server) as the operating system

### Software Infrastructure Technologies

The technologies used to set up the software infrastructure on the project environment are:

- [Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html) for defining and provisioning the necessary software infrastructure as code
- [Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html) for collecting logs from Syslog and Filebeat, transforming and sending them to Elasticsearch
- [Docker Engine](https://docs.docker.com/engine/) for running containerized applications
- [Docker Compose](https://docs.docker.com/compose/) for defining and running multi-container Docker applications
- [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html) to store log data received from Apache NiFi
- [Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-overview.html) for shipping logs to Apache NiFi
- [Grafana](https://grafana.com/oss/grafana/) to monitor underlying OS with metrics stored on InfluxDB
- [InfluxDB](https://www.influxdata.com/products/influxdb/) for storing metrics received from Telegraf
- [Kibana](https://www.elastic.co/guide/en/kibana/current/get-started.html) for observing data stored in Elasticsearch
- [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) for collecting all OS metrics and and sending them to InfluxDB to store

## Environment and Software Infrastructure Setup

This section provides basic information about the project environment and software infrastructure as well as the links to begin setup processes.

### Environment Setup

The environment of the project has been designed to be created in the cloud (AWS) with Terraform. Once the code is run, the AWS resources required to build the environment are created. Follow [**this**](./infrastructure/terraform/aws/README.md) link for more information and getting started with environment setup.

### Software Infrastructure Setup

It's already been mentioned about the components which bring up the software infrastructure in the  [Software Infrastructure Technologies](#software-infrastructure-technologies) section. These components form three main application stacks by coming together:

1. **Elastic Stack**, which is the storage and observability center of the collected log data. 
2. **NiFi Stack**, which is the collector, transformer and shipper of log data.
3. **Monitoring Stack**, which is the gatherer, storekeeper and visualizer of the collected metric data of the host operating system.

For more information and to get started, follow [**this**](./infrastructure/ansible/README.md) link.
