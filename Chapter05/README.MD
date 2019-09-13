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

# Using Kafka operations
With the Confluent Platform installed, the administration, operation, and monitoring of Kafka become very simple. Let's review how to operate Kafka with the Confluent Platform.

## Getting ready
For this recipe, Confluent should be installed, up, and running.

The commands in this section should be executed from the directory where the Confluent
Platform is installed:

1. To start ZooKeeper, Kafka, and the Schema Registry with one command, run:

```bash
$ confluent local  start schema-registry
```

The output of this command should be:

```bash
Starting zookeeper
zookeeper is [UP]
Starting kafka
kafka is [UP]
Starting schema-registry
schema-registry is [UP]
```

To execute the commands outside the installation directory, add
Confluent's bin directory to PATH :

```bash
export PATH=<path_to_confluent>/bin:$PATH
```

2. To manually start each service with its own command, run:

```bash
$ ./bin/zookeeper-server-start ./etc/kafka/zookeeper.properties
$ ./bin/kafka-server-start ./etc/kafka/server.properties
$ ./bin/schema-registry-start ./etc/schema-registry/schema-registry.properties
```

Note that the syntax of all the commands is exactly the same as always but without the .sh extension.

3. To create a topic called test_topic , run the following command:

```bash
$ ./bin/kafka-topics --zookeeper localhost:2181 --create --topic test_topic --partitions 1 --replication-factor 1
```

4. To send an Avro message to test_topic in the broker without writing a single line of code, use the following command:

```bash
$ ./bin/kafka-avro-console-producer --broker-list localhost:9092 --topic test_topic --property  value.schema='{"name":"person","type":"record", "fields":[{"name":"name","type":"string"},{"name":"age","type":"int"}]}'
```
5. Send some messages and press Enter after each line:

```bash
{"name": "Alice", "age": 27}
{"name": "Bob", "age": 30}
{"name": "Charles", "age":57}
```

6. Enter with an empty line is interpreted as null. To shut down the process, press Ctrl + C.
7. To consume the Avro messages from test_topic since the beginning, type:

```bash
$ ./bin/kafka-avro-console-consumer --topic test_topic --zookeeper  localhost:2181 --from-beginning
```

The messages created in the previous step will be written to the console in the format they were introduced.

8. To shut down the consumer, press Ctrl + C.

9. To test the Avro schema validation, try to produce data on the same topic using an incompatible schema, for example, with this producer:

```bash
$ ./bin/kafka-avro-console-producer --broker-list localhost:9092  --topic test_topic --property value.schema='{"type":"string"}'
```
10. After you've hit Enter on the first message, the following exception is raised:

```bash
org.apache.kafka.common.errors.SerializationException: Error deserializing json  to Avro of schema "string"
Caused by: java.io.EOFException
	at org.apache.avro.io.JsonDecoder.advance(JsonDecoder.java:138)
	at org.apache.avro.io.JsonDecoder.readString(JsonDecoder.java:219)
	at org.apache.avro.io.JsonDecoder.readString(JsonDecoder.java:214)
	at org.apache.avro.io.ResolvingDecoder.readString(ResolvingDecoder.java:201)
	at org.apache.avro.generic.GenericDatumReader.readString(GenericDatumReader.java:430)
	at org.apache.avro.generic.GenericDatumReader.readString(GenericDatumReader.java:422)
	at org.apache.avro.generic.GenericDatumReader.readWithoutConversion(GenericDatumReader.java:180)
	at org.apache.avro.generic.GenericDatumReader.read(GenericDatumReader.java:152)
	at org.apache.avro.generic.GenericDatumReader.read(GenericDatumReader.java:144)
	at io.confluent.kafka.formatter.AvroMessageReader.jsonToAvro(AvroMessageReader.java:213)
	at io.confluent.kafka.formatter.AvroMessageReader.readMessage(AvroMessageReader.java:180)
	at kafka.tools.ConsoleProducer$.main(ConsoleProducer.scala:55)
	at kafka.tools.ConsoleProducer.main(ConsoleProducer.scala)
```

11. To shut down the services (Schema Registry, broker, and ZooKeeper) run:

```bash
confluent local stop
```

12. To delete all the producer messages stored in the broker, run this:

```bash
confluent local destroy
```

### There's more...
With the Confluent Platform, it is possible to manage all of the Kafka system through the Kafka operations, which are classified as follows:

*  Production deployment: Hardware configuration, file descriptors, and ZooKeeper configuration
*  Post deployment: Admin operations, rolling restart, backup, and restoration
*  Auto data balancing: Rebalancer execution and decommissioning brokers
*  Monitoring: Metrics for each concept—broker, ZooKeeper, topics, producers,and consumers
*  Metrics reporter: Message size, security, authentication, authorization, and verification

### See also
To see the complete list of Kafka operations available, check out this URL:
https://docs.confluent.io/current/kafka/operations.html

## Monitoring with the Confluent Control Center

This recipe shows you how to use the metrics reporter of the Confluent Control Center.

### Getting ready

The execution of the previous recipe is needed.
Before starting the Control Center, configure the metrics reporter:
1.  Back up the server.properties file located at:

```bash
<confluent_path>/etc/kafka/server.properties
```

2. In the server.properties file, uncomment the following lines:

```propertis
metric.reporters=io.confluent.metrics.reporter.ConfluentMetricsRepo
rter
confluent.metrics.reporter.bootstrap.servers=localhost:9092
confluent.metrics.reporter.topic.replicas=1
```

3. Back up the Kafka Connect configuration located in:

```
<confluent_path>/etc/schema-registry/connect-avro-distributed.properties
```

4. Add the following lines at the end of the **connect-avro-distributed.properties** file:

```
consumer.interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor
producer.interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor
```

5. Start the Confluent Platform:

```bash
$ <confluent_path>/bin/confluent start
```

Before starting the Control Center, change its configuration:


6. Back up the control-center.properties file located in:

```
<confluent_path>/etc/confluent-control-center/control-center.properties
```

7. Add the following lines at the end of the control-center.properties file:

```
confluent.controlcenter.internal.topics.partitions=1
confluent.controlcenter.internal.topics.replication=1
confluent.controlcenter.command.topic.replication=1
confluent.monitoring.interceptor.topic.partitions=1
confluent.monitoring.interceptor.topic.replication=1
confluent.metrics.topic.partitions=1
confluent.metrics.topic.replication=1
```

8. Start the Control Center:

```
<confluent_path>/bin/control-center-start
```