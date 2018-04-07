# Alot of duplicate code but the functions feel cleaner this way.
# If using one function instead of two, the need for a parameter which states
# where the output should be redirected is needed
# Example usage below
#
# source /path/to/logging.sh
# log "Script ran as expected"
# log_err "Script failed horribly"

function log() {
	name="$(basename $0)"
	prefix="$(date "+%F %H:%M:%S") ${name} - "
	printf "${prefix}%s\n" "$@"
	if [ ! -z ${LOG_DIR} ]
	then
		printf "${prefix}%s\n" "$@" >> "${LOG_DIR}/${name}.log"
	fi
}

function log_err() {
	name="$(basename $0)"
	prefix="$(date "+%F %H:%M:%S") ${name} - "
	printf "${prefix}%s\n" "$@" >> /dev/stderr
	if [ ! -z ${LOG_DIR} ]
	then
		printf "${prefix}Err: %s\n" "$@" >> "${LOG_DIR}/${name}.log"
	fi
}
