#!/bin/bash
#
# Decided to still have this file named .sh to make it clear in the Dockerfile
# that it is a shellscript.
#
# Write .pgpass file for psql and pg_dumpall
# Then start cron in foreground mode, to keep it from exiting,
# which would cause the container to exit

mkdir -p ${LOG_DIR}

source logging.sh

#Evaluates to true if variable is either unset or empty
if [ -z "${POSTGRES_PASSWORD_FILE}" ]
then
	#~/.pgpass is written in the format hostname:port:database:username:password
	echo "${POSTGRES_NAME}:*:*:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > ~/.pgpass
else

	if [ ! -f ${POSTGRES_PASSWORD_FILE} ]
	then
		log_err "No password file found at: ${POSTGRES_PASSWORD_FILE}"
		exit 1
	else
		echo "${POSTGRES_NAME}:*:*:${POSTGRES_USER}:$(cat ${POSTGRES_PASSWORD_FILE})" > ~/.pgpass
	fi
fi

chmod 600 ~/.pgpass

# exec makes sure crond starts with the same pid as this script is run as,
# otherwise docker might shutdown the container.
exec "$@"
