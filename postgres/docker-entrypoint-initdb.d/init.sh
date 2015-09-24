#!/bin/bash

echo "Creating cms user"
gosu postgres postgres --single -jE <<-EOSQL
create user cms with password '$CMS_DB_PASSWORD';
EOSQL

echo "Creating dabase"
gosu postgres postgres --single -jE <<-EOSQL
CREATE DATABASE "cms" WITH OWNER "cms";
EOSQL
