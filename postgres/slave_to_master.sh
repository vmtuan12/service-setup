#!/bin/bash

sudo -i -u postgres psql postgres -c "SELECT pg_promote();"

sudo -i -u postgres psql postgres -c "ALTER USER replicator WITH PASSWORD 'postgres';"

counter=1
while true; do
    arg=${!counter}

    if [ -z "$arg" ]; then
        break
    else
        (sudo cat /etc/postgresql/12/main/pg_hba.conf | grep "host    replication     replicator      $arg/24        md5") > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            echo "host    replication     replicator      $arg/24        md5" | sudo tee -a /etc/postgresql/12/main/pg_hba.conf
        fi
    fi

    counter=$((counter + 1))
done

sudo systemctl restart postgresql@12-main.service