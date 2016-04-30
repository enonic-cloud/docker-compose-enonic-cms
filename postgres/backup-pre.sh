#!/bin/bash

echo "Dumping cms db"
export PGPASSWORD=$POSTGRES_ENV_CMS_DB_PASSWORD
pg_dump -h localhost -U cms -Fc -f /backup/cms.psql 
