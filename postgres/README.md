# Postgresql HA installation

2 Nodes: 1 Master node (192.168.56.65), 2 Slave nodes (192.168.56.66, 192.168.56.67)\
OS: Ubuntu 20.04.6\
Postgresql version: 12

## On every nodes

```
sudo apt-get update
sudo apt install postgresql
```

In `/etc/postgresql/12/main/postgresql.conf`, add the following line
```
listen_addresses = '*'
```

In `/etc/postgresql/12/main/pg_hba.conf`, modify the following lines
```
# IPv4 local connections:
host    all             all             0.0.0.0/0               scram-sha-256
# allow IPv4 connections, change to specific IP if needed
```

Edit password for `postgres` user
```
sudo -u postgres psql template1
```
In psql shell
```
ALTER USER postgres with encrypted password 'your_password';
```

Exit psql, then restart postgresql service

```
sudo systemctl restart postgresql@12-main.service
```

Be sure that port 5432 has been opened
```
sudo iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
sudo iptables-save > ~/iptables
sudo iptables-restore < ~/iptables
```

## On Master node

```
sudo su - postgres
createuser --replication -P -e replicator
exit
```

In `/etc/postgresql/12/main/pg_hba.conf`, add following line
```
host    replication     replicator      192.168.56.66/24        md5
```

Restart postgresql
```
systemctl restart postgresql@12-main.service
```

## On Slave nodes

Stop postgresql
```
systemctl stop postgresql@12-main.service
```

Login user postgres using `sudo su - postgres`

Remove files in data directory
```
rm -rf /var/lib/postgresql/12/main/*
```

Copy data from Master
```
pg_basebackup -h 192.168.56.65 -D /var/lib/postgresql/12/main -U replicator -P -v -R -X stream -C -S slave_1
```

Options
```
-h – specifies the host which is the master server.
-D – specifies the data directory.
-U – specifies the connection user.
-P – enables progress reporting.
-v – enables verbose mode.
-R – enables the creation of recovery configuration: Creates a standby.signal file and append connection settings to postgresql.auto.conf under the data directory.
-X – used to include the required write-ahead log files (WAL files) in the backup. A value of stream means to stream the WAL while the backup is created.
-C – enables the creation of a replication slot named by the -S option before starting the backup.
-S – specifies the replication slot name.
```

Exit user `postgres` then restart postgresql
```
systemctl start postgresql@12-main.service
```

## Testing
On Master node, use the query `select * from pg_replication_slots;` to check whether the slaves are installed and set up correctly. The result looks like
```
slot_name | plugin | slot_type | datoid | database | temporary | active | active_pid | xmin | catalog_xmin | restart_lsn | confirmed_flush_lsn 
----------+--------+-----------+--------+----------+-----------+--------+------------+------+--------------+-------------+---------------------
slave_1   |        | physical  |        |          | f         | t      |      23173 |      |              | 0/B000060   | 
slave_2   |        | physical  |        |          | f         | t      |      23270 |      |              | 0/B000060   | 
(2 rows)
```
If the value of the `active` column is `t`, then the slave is ok.
