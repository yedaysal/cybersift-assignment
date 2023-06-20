![cybersift-logo](./resources/images/cybersift-logo.png)

# Cybersift Assignment Repository

Repository that contains the code to setup the necessary environment and software infrastructure, guidelines, and assignment report.

## Table of Contents

- [Introduction - The Project's Aim](#introduction---the-projects-aim)
- [Environment and Software Infrastructure Setup](#environment-and-software-infrastructure-setup)
- [Technologies](#technologies)
  - [Environment Technologies](#environment-technologies)
  - [Software Infrastructure Technologies](#software-infrastructure-technologies)

## Introduction - The Project's Aim

The goal of the project is to accomplish the following assignment objectives:

1. Install [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html) (and [Kibana](https://www.elastic.co/guide/en/kibana/current/get-started.html)), and install [Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html) on a CentOS or Ubuntu VM.
2. Build a simple NiFi pipeline which accepts syslog on local port UDP 514 and sends it on to Elasticsearch.
3. Use [Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html) and build a simple Nifi pipeline which gathers data from the local `/var/log/messages`, and sends it on to Elasticsearch.
4. Setup or otherwise show how you would monitor the OS and NiFi using [InfluxDB and Telegraf](https://portal.influxdata.com/downloads/).

## Environment and Software Infrastructure Setup

The 

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

- [Ansible]() for defining and provisioning the necessary software infrastructure as code
- [Apache NiFi]() for collecting logs from Syslog and Filebeat, transforming and sending them to Elasticsearch
- [Docker Engine]() for running containerized applications
- [Docker Compose]() for defining and running multi-container Docker applications
- [Elasticsearch]() to store log data received from Apache NiFi
- [Filebeat]() for shipping logs to Apache NiFi
- [Grafana]() to monitor underlying OS with metrics stored on InfluxDB
- [InfluxDB]() for storing metrics received from Telegraf
- [Kibana]() for observing data stored in Elasticsearch
- [Telegraf]() for collecting all OS metrics and and sending them to InfluxDB to store
