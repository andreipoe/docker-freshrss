#!/bin/bash
set -e

FRSS_TIMEZONE="${FRSS_TIMEZONE:-Europe/Paris}"
FRSS_REFRESH="${FRSS_REFRESH:-3600}"

appInit() {
    # create log dir
    mkdir -p ${FRSS_LOG_DIR}

    # set timezone
    echo -e "[php]\ndate.timezone=${FRSS_TIMEZONE}\n" > /usr/local/etc/php/php.ini

    # look for empty dir
    [[ "$(ls -A ${FRSS_DATA_DIR})" ]] || {
	cp -r ${FRSS_SETUP_DIR} ${FRSS_HOME}
	chown -R :www-data ${FRSS_HOME}
	chmod -R g+w ${FRSS_DATA_DIR}
    }
}

refreshFeed() {
    while :
    do
	php ${FRSS_HOME}/app/actualize_script.php >> ${FRSS_LOG_DIR}/refresh.log 2>&1
	sleep ${FRSS_REFRESH}
    done
}

appStart () {
    appInit

    # launch auto-refresh
    echo "Launching feed auto-refresh..."
    refreshFeed &

    # start apache
    echo "Starting Apache Server..."
    exec apache2-foreground
}

appHelp () {
    echo "Available options:"
    echo " app:start          - Starts FreshRSS (default)"
    echo " app:init           - Init FreshRSS, but don't start it"
    echo " app:help           - Displays the help"
    echo " [command]          - Execute the specified linux command eg. bash."
}

case ${1} in
    app:start)
	appStart
	;;
    app:init)
	appInit
	;;
    *)
	if [[ -x $1 ]]; then
	    $1
	else
	    prog=$(which $1)
	    if [[ -n ${prog} ]] ; then
		shift 1
		$prog $@
	    else
		appHelp
	    fi
	fi
	;;
esac
