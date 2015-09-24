# Enonic CMS installation container

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