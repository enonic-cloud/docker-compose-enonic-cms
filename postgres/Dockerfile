FROM postgres:9.4.1

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

COPY em-import.sh /usr/local/bin/em-import.sh
RUN chmod +x /usr/local/bin/em-import.sh

COPY em-export.sh /usr/local/bin/em-export.sh
RUN chmod +x /usr/local/bin/em-export.sh