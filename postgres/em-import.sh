#!/bin/bash

# Checking number of databases
if [ ! $(ls -1 /data/*.psql | wc -l) -eq 1 ]
	then
	echo "Found Zero, or more than one .psql files in em-backup, Need to have just one please."
	exit 1
fi

PG_FILE=$(ls /data/*.psql | tail -n 1)

echo "Restoring database"
export PGPASSWORD=$POSTGRES_ENV_CMS_DB_PASSWORD
pg_restore -h postgres -U cms -d cms -O $PG_FILE

echo "Importing cms.home/data"
cp -rf /data/cms.home/data/* /cms.home/data/.

echo "Importing cms.home/index"
cp -rf /data/cms.home/index/* /cms.home/index/.
