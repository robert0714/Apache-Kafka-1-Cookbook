#!/bin/bash
# ubuntu
value=$( grep -ic "entry" /etc/hosts )
if [ $value -eq 0 ]
then
echo "
127.0.0.1       localhost
::1             localhost
################ cassandra-cookbook host entry ############
107.170.38.238  MACHINE01
107.170.112.81  MACHINE02
107.170.115.161 MACHINE03
######################################################
" > /etc/hosts
fi
# sudo apt-get update
sudo apt-get  install -y rsync openjdk-8-jdk  nfs-common portmap  
sudo ln -s java-8-openjdk-amd64 /usr/lib/jvm/jdk

sudo sh -c 'echo export JAVA_HOME=/usr/lib/jvm/jdk/ >> /home/hduser/.bashrc'

# Add hadoop user
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
echo hduser:hduser | sudo chpasswd
sudo adduser hduser sudo

sudo -u hduser ssh-keygen -t rsa -P '' -f /home/hduser/.ssh/id_rsa
sudo sh -c  "cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys"
# Prevent ssh setup questions
sudo sh -c  "printf 'NoHostAuthenticationForLocalhost yes
 Host *  
    StrictHostKeyChecking no' > /home/hduser/.ssh/config"

# Download Scala to the vagrant shared directory if it doesn't exist yet
cd /vagrant
if [ ! -f scala-2.12.9.tgz ]; then
	wget https://www.scala-lang.org/files/archive/scala-2.12.9.tgz
fi
# Unpack Scala and install
sudo tar vxzf scala-2.12.9.tgz -C /usr/local
cd /usr/local
sudo mv scala-2.12.9 scala
sudo chown -R hduser:hadoop scala

# scala variables
sudo sh -c 'echo export SCALA_HOME=/usr/local/scala >> /home/hduser/.bashrc'
sudo sh -c 'echo export PATH=\$PATH:\$SCALA_HOME/bin >> /home/hduser/.bashrc'

# Download confluent- to the vagrant shared directory if it doesn't exist yet
cd /vagrant
if [ ! -f confluent-5.3.0-2.12.tar.gz ]; then
	wget http://packages.confluent.io/archive/5.3/confluent-5.3.0-2.12.tar.gz
fi
# Unpack zookeeper and install
sudo tar vxzf  confluent-5.3.0-2.12.tar.gz  -C /usr/local
cd /usr/local
sudo mv confluent-5.3.0  confluent
sudo chown -R hduser:hadoop confluent

# zookeeper variables
sudo sh -c 'echo export CONFLUENT_HOME=/usr/local/confluent >> /home/hduser/.bashrc'
sudo sh -c 'echo export PATH=\$PATH:\$CONFLUENT_HOME/bin >> /home/hduser/.bashrc'


sudo curl https://bintray.com/sbt/rpm/rpm > bintray-sbt-rpm.repo
sudo mv bintray-sbt-rpm.repo /etc/yum.repos.d/
sudo yum install -y sbt   screen  lsof
