#!/bin/bash

sudo -i -u postgres psql postgres -c "SELECT pg_promote();"

sudo systemctl stop postgresql@12-main.service

sudo -u postgres bash -c 'rm -r /var/lib/postgresql/12/main/*'

slave_name=$(echo "$2" | tr . _)
sudo -u postgres PGPASSWORD="postgres" pg_basebackup -h "$1" -D /var/lib/postgresql/12/main -U replicator -P -v -R -X stream -C -S "$slave_name"

sudo systemctl start postgresql@12-main.service