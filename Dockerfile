FROM alpine:3.7

ENV POSTGRES_NAME postgres
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_PASSWORD_FILE ""
ENV BACKUP_DIR /backup
ENV LOG_DIR /var/log


# postgresql-libs is required for using a .pgpass file
# bash is required for the exec trick in docker-entrypoint.sh
RUN ["apk", "--no-cache", "add", "postgresql-client=10.3-r0", "postgresql-libs=10.3-r0", "bash", "tzdata"]

COPY backup-script /scripts/backup
COPY crontab /scripts/crontab
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY logging.sh /usr/local/bin/logging.sh

RUN ["chmod", "755", "/scripts/backup"]
RUN ["chmod", "755", "/scripts/crontab"]
RUN ["chmod", "755", "/usr/local/bin/docker-entrypoint.sh"]

RUN ["crontab", "-u", "root", "/scripts/crontab"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["crond", "-f"]
