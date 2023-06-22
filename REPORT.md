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

