# Chapter 5  The Confluent Platform
This chapter covers the following recipes:
*  Installing the Confluent Platform
*  Using Kafka operations
*  Monitoring with the Confluent Control Center
*  Using the Schema Registry
*  Using the Kafka REST Proxy
*  Using Kafka Connect
 

## Introduction
The Confluent Platform is a full stream data system. It enables you to organize and manage data from several sources in one high-performance and reliable system. As mentioned in the first few chapters, the goal of an enterprise service bus is not only to provide the system a means to transport messages and data but also to provide all the tools that are required to connect the data origins (data sources), applications, and data destinations (data sinks) to the platform.

The Confluent Platform has these parts:
*  Confluent Platform open source
*  Confluent Platform enterprise
*  Confluent Cloud

The Confluent Platform open source has the following components:
*  Apache Kafka core
*  Kafka Streams
*  Kafka Connect
*  Kafka clients
*  Kafka REST Proxy
*  Kafka Schema Registry

The Confluent Platform enterprise has the following components:
*  Confluent Control Center
*  Confluent support, professional services, and consulting

All the components are open source except the Confluent Control Center, which is a proprietary of Confluent Inc.
An explanation of each component is as follows:

*  **Kafka core**: The Kafka brokers discussed at the moment in this book.
*  **Kafka Streams**: The Kafka library used to build stream processing systems.
*  **Kafka Connect**: The framework used to connect Kafka with databases, stores,and filesystems.
*  **Kafka clients**: The libraries for writing/reading messages to/from Kafka. Note that there clients for these languages: Java, Scala, C/C++, Python, and Go.
*  **Kafka REST Proxy**: If the application doesn't run in the Kafka clients'programming languages, this proxy allows connecting to Kafka through HTTP.
*  **Kafka Schema Registry**: Recall that an enterprise service bus should have a message template repository. The Schema Registry is the repository of all the schemas and their historical versions, made to ensure that if an endpoint changes, then all the involved parts are acknowledged.
*  **Confluent Control Center**: A powerful web graphic user interface for managing and monitoring Kafka systems.
*  **Confluent Cloud**: Kafka as a service—a cloud service to reduce the burden of
operations.


## Installing the Confluent Platform
In order to use the REST proxy and the Schema Registry, we need to install the Confluent Platform. Also, the Confluent Platform has important administration, operation, and monitoring features fundamental for modern Kafka production systems.

### Getting ready
At the time of writing this book, the Confluent Platform Version is 4.0.0. Currently, the supported operating systems are:

*  Debian 8
*  Red Hat Enterprise Linux
*  CentOS 6.8 or 7.2
*  Ubuntu 14.04 LTS and 16.04 LTS

macOS currently is just supported for testing and development purposes, not for production environments. Windows is not yet supported. Oracle Java 1.7 or higher is required.

The default ports for the components are:

*  2181: Apache ZooKeeper
*  8081: Schema Registry (REST API)
*  8082: Kafka REST Proxy
*  8083: Kafka Connect (REST API)
*  9021: Confluent Control Center
*  9092: Apache Kafka brokers

It is important to have these ports, or the ports where the components are going to run, open.

## How to do it...
There are two ways to install: downloading the compressed files or with apt-get command.
To install the compressed files:

1. Download the Confluent open source v4.0 or Confluent Enterprise v4.0 TAR files from https://www.confluent.io/download/

2. Uncompress the archive file (the recommended path for installation is under /opt)

3. To start the Confluent Platform, run this command:

```bash
$ <confluent-path>/bin/confluent start
```

or see [documents](https://docs.confluent.io/current/quickstart/ce-quickstart.html#ce-quickstart)

```bash
[vagrant@MACHINE01 ~]$ <path-to-confluent>/bin/confluent-hub install \
--no-prompt confluentinc/kafka-connect-datagen:latest

[vagrant@MACHINE01 ~]$ curl -L https://cnfl.io/cli | sh -s -- -b /usr/local/confluent/bin

[vagrant@MACHINE01 ~]$ <path-to-confluent>/bin/confluent local start
```


The output should be as follows:

```
Starting zookeeper
zookeeper is [UP]
Starting kafka
kafka is [UP]
Starting schema-registry
schema-registry is [UP]
Starting kafka-rest
kafka-rest is [UP]
Starting connect
connect is [UP]
```

### Create Kafka Topics

In this step, you create Kafka topics by using the Confluent Control Center. [Confluent Control Center](https://docs.confluent.io/current/control-center/index.html#control-center) provides the functionality for building and monitoring production data pipelines and event streaming applications.

Navigate to the Control Center web interface at http://107.170.38.238:9021/.