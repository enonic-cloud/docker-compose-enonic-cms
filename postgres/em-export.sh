#!/bin/bash

echo "Dumping postgres db"
export PGPASSWORD=$POSTGRES_ENV_CMS_DB_PASSWORD
pg_dump -h postgres -U cms -Fc -f /data/cms.psql 

echo "Copying cms.home"
cp -r /cms.home /data/.