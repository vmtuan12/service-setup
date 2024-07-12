# Hive installation

## Package

Download package:

```
https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
```

## Setup (Master only)

Unpack

```
tar -xvzf apache-hive-3.1.3-bin.tar.gz
mv apache-hive-3.1.3-bin hive
```

Edit `~/.bashrc`

```
export HIVE_HOME=/home/vagrant/hive
export PATH=$PATH:$HIVE_HOME/sbin:$HIVE_HOME/bin
export CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:$HIVE_HOME/lib/*
```

```
source ~/.bashrc
```

Configure `hive-site.xml`

```
cp $HIVE_HOME/conf/hive-default.xml.template $HIVE_HOME/conf/hive-site.xml
```

In `$HIVE_HOME/conf/hive-site.xml`
```

```
