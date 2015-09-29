# Enonic CMS installation container
## Installation
- Clone `https://github.com/enonic-cloud/docker-compose-enonic-cms`
```
cd /srv
git clone https://github.com/enonic-cloud/docker-compose-enonic-cms <your Enonic CMS installation name>
cd <your Enonic CMS installation name>
```
- Modify the `CMS_DB_PASSWORD` and `POSTGRES_PASSWORD` fields in the `docker-compose.yml` file. These will reflect the passwords for the postgres and cms database users internaly in the setup.
- Download a Enonic CMS release and extract it.
- Copy $CMS_HOME/config and $CMS_HOME/plugins to the cms/cms.home/ folder. Modify the files accordingly to the Enonic CMS dockumentation.
- Then place the war file in cms/webapps folder as ROOT.war.
- Build the containers with the command `docker-compose build`
- Now launch the container set with `docker-compose up -d`

## Restore Enonic CMS backup
NOTE: This should be done localy on the server as we are mounting up local volumes inside of the container
- Copy $CMS_HOME/config and $CMS_HOME/plugins to the cms/cms.home/ folder.
- Then place the war file in cms/webapps folder.
- Build the containers with the command `docker-compose build`
- Run this command to create the storage containers and import $CMS_HOME/data and $CMS_HOME/index + database. $CMS_BACKUP points to the base of the em-backup folder.

```
export CMS_BACKUP=/home/ladmin/cms-enonic_stk-kraven-2015-09-22_21-34-45
docker-compose up -d cmsstorage postgres
docker run -it --rm -v $CMS_BACKUP:/data --volumes-from enoniccms_cmsstorage_1 --link enoniccms_postgres_1:postgres enoniccms_postgres em-import.sh

```

- Now its time to make a apache vhost for you site(s). Use the example file "apache2/sites/vhost.example.conf.example" and create apache2 vhost config named "servername.com.conf". Make shure it has ".conf" at the end, or it will not be loaded by apache. If you need to load extra module og customize the apache2 container, feel free to do that in the file "apache2/Dockerfile". 
- Start up the rest of the containers with the command `docker-compose up -d --no-recreate`

## Backup Enonic CMS installation
The postgres container has a script to dump the complete installation storage to /data folder. Run a seperate docker container to extract the "Persistant" storage out of the containers. Combine this with the non persistant data, you have a complete backup of your installation.

- Create the file `/usr/local/bin/cms-backup` and put this content in it: 
```
#!/bin/bash

INSTANCE=<your instance name>
rm -rf /srv/_backup/$INSTANCE/*
docker run --rm -v /srv/_backup/$INSTANCE:/data --volumes-from $INSTANCE"_cmsstorage_1" --link $INSTANCE"_postgres_1":postgres $INSTANCE"_postgres" em-export.sh
```
- Run `chmod +x /usr/local/bin/cms-backup` to make it executable
- Add it to cron by running `crontab -e` and add this line to the end:
```
1 0 * * * /usr/local/bin/cms-backup  >> /var/log/cms-backup.log 2>&1
```