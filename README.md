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
- Copy $CMS_HOME/config and $CMS_HOME/plugins to the cms/cms.home/ folder. Modify the files accordingly to the Enonic CMS documentation.
- Then place the war file in cms/webapps folder as ROOT.war.
- Build the containers with the command `docker-compose build`
- Now launch the container set with `docker-compose up -d`

## Restore Enonic CMS backup
- Prepare a new installation as described above, but **DO NOT START** the container set with `docker-compose up -d`
- Instead do
```
docker-compose up -d --no-deps cmsstorage
```
We create a temporary cms container to upload the content.

```
docker run -it --rm -volumes-from <project>_cmsstorage_1 -u root <project>_cms bash
```

Use `docker cp` command to copy $CMS_HOME/data and $CMS_HOME/index to `/cms.home/` in the cms container. 

```
docker cp $CMS_HOME/data <PROJECT>_cms_1:/cms.home/
docker cp $CMS_HOME/index <PROJECT>_cms_1:/cms.home/
```

Then start the postgres service
```
docker-compose up -d postgres
```
Now copy the postgresql dump to `/backup` in  the postgres container and run `/usr/local/bin/backup-restore.sh`
```
docker cp <cms.psql> <PROJECT>_postgres_1:/backup

docker exec <PROJECT_postgres_1 /usr/local/bin/backup-restore.sh
```
Now its time to make a apache vhost for you site(s). Use the example file "apache2/sites/vhost.example.conf.example" and create apache2 vhost config named "servername.com.conf". Make sure it has ".conf" at the end, or it will not be loaded by apache. If you need to load extra module og customize the apache2 container, feel free to do that in the file "apache2/Dockerfile".

Start up the rest of the containers with the command
```
docker-compose up -d --no-recreate
```

## Backup Enonic CMS installation
- Run `/usr/local/bin/backup-pre.sh` in the running postgres container to export postgres database to the folder /backup folder
- Backup the folder `/backup` from the container to you backup directory.
- Run `/usr/local/bin/backup-post.sh` in the same container to clean up.
- Copy put `/cms.home` from the Enonic CMS container.
