# Postgresql HA installation

2 Nodes: 1 Master node, 1 Slave node
OS: Ubuntu

## On every node

```
sudo apt-get update
sudo apt install postgresql
```

In `/etc/postgresql/<version>/main/pg_ident.conf`, add the following line
```
listen_addresses = '*'
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
sudo systemctl restart postgresql.service
```

