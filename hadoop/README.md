# Hadoop cluster installation

Install Hadoop with 1 Master and 1 Slave\
OS: Ubuntu

## Package

Download package:

```
https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
```

## Setup

### On both machines

Setup SSH key

```
sudo apt-get install openssh-server openssh-client
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

ssh-copy-id user_name@server_ip
```

Edit `/etc/hosts`, add the below information, each host on a new line

```
<ip> <hostname>
```

Install Java

```
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
```

Unpack

```
tar -xvzf hadoop-3.4.0.tar.gz
mv hadoop-3.4.0 hadoop
```

Edit the `~/.bashrc`

```
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/home/vagrant/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
```

```
source ~/.bashrc
```

Edit configuration

In `/home/vagrant/hadoop/etc/hadoop/core-site.xml`
```
<configuration>
<property>
<name>fs.default.name</name>
<value>hdfs://<master-node-ip>:9000</value>
</property>
<property>
<name>hadoop.tmp.dir</name>
<value>/home/vagrant/hadoop/tmp</value>
</property>
</configuration>
```

In `/home/vagrant/hadoop/etc/hadoop/hdfs-site.xml`
```
<configuration>
<property>
<name>dfs.replication</name>
<value>1</value>
</property>
<property>
<name>dfs.namenode.name.dir</name>
<value>file:///usr/local/hadoop/hdfs/data</value>
</property>
</configuration>
```

In `/home/vagrant/hadoop/etc/hadoop/yarn-site.xml`
```
<configuration>
<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>
<property>
<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
<value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>
<property>
<name>yarn.resourcemanager.hostname</name>
<value><master-node-hostname-or-ip></value>
</property>
</configuration>
```

In `/home/vagrant/hadoop/etc/hadoop/mapred-site.xml` (Map-reduce configuration)

```
<configuration>
<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>
<property>
<name>yarn.app.mapreduce.am.env</name>
<value>HADOOP_MAPRED_HOME=/home/vagrant/hadoop</value>
</property>
<property>
<name>mapreduce.map.env</name>
<value>HADOOP_MAPRED_HOME=/home/vagrant/hadoop</value>
</property>
<property>
<name>mapreduce.reduce.env</name>
<value>HADOOP_MAPRED_HOME=/home/vagrant/hadoop</value>
</property>
<property>
<name>mapreduce.application.classpath</name>
<value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*,$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*,$HADOOP_MAPRED_HOME/share/hadoop/common/*,$HADOOP_MAPRED_HOME/share/hadoop/common/lib/*,$HADOOP_MAPRED_HOME/share/hadoop/yarn/*,$HADOOP_MAPRED_HOME/share/hadoop/yarn/lib/*,$HADOOP_MAPRED_HOME/share/hadoop/hdfs/*,$HADOOP_MAPRED_HOME/share/hadoop/hdfs/lib/*</value>
</property>
</configuration>
```

In `/home/vagrant/hadoop/etc/hadoop/workers`, add all the worker nodes' IP, each on a new line.\
In `/home/vagrant/hadoop/etc/hadoop/masters`, add the master node's IP.

Create folders
```
mkdir hadoop/tmp
sudo mkdir -p /usr/local/hadoop/hdfs/data
sudo chown user_name:user_name-R /usr/local/hadoop/hdfs/data
chmod 700 /usr/local/hadoop/hdfs/data
```

Edit `/etc/environment`
```
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/hadoop/bin:/usr/local/hadoop/sbin"
JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
```

```
source /etc/environment
```

> [!NOTE]  
> If encountering the error `Permission denied (publickey,password)` when starting the Datanode, add `export HADOOP_SSH_OPTS="-p 22"` to `hadoop/etc/hadoop/hadoop-env.sh`

### Run

```
hdfs namenode -format
```

```
start-all.sh
```
