# Hive installation

## Package

Download package:

```
https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz
```

## Setup

Unpack
```
tar -xvzf spark-3.5.1-bin-hadoop3.tgz
mv spark-3.5.1-bin-hadoop3 spark
```

Edit `~/.bashrc`
```
export SPARK_HOME=/home/vagrant/spark
export PYSPARK_PYTHON=/home/vagrant/spark_code/venv/env_python310/bin/python3
```

```
source ~/.bashrc
```

Create `$SPARK_HOME/conf/spark-env.sh` in Master node, and add this line
```
export SPARK_MASTER_HOST=<master-node hostname> export SPARK_MASTER_PORT=7077
```

Create `$SPARK_HOME/conf/spark-env.sh` in Worker node(s), and add this line
```
export SPARK_MASTER=spark://<master-node hostname>:7077
```

## Run

On Master node, run
```
$SPARK_HOME/sbin/start-master.sh
```

On Worker node(s), run
```
$SPARK_HOME/sbin/start-worker.sh spark://<master-node hostname>:7077
```
