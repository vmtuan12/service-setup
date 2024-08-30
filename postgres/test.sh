#!/bin/bash

is_slave=$(sudo -i -u postgres psql -U postgres -tA -c "SELECT CASE WHEN pg_is_in_recovery() THEN 'True' ELSE 'False' END;")

echo "$is_slave"