FROM enoniccloud/enonic-cms
# If Enonic CMS 4.5 or earlier, use "FROM enoniccloud/enonic-cms-jdk6" as JDK7 support was added in Enonic CMS 4.7

# Set timezone to Europe/Oslo
RUN echo "Europe/Oslo" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
# Copy the 
COPY webapps/ROOT.war $CATALINA_HOME/webapps/

COPY cms.home $CMS_HOME
