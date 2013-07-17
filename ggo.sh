#!/usr/bin/env bash
#####################################################################
# Gravity Gun Only bash script                                      #
# developed by Pricetx.                                             #
#####################################################################

####    INGAME SETTINGS    ####
#### EDIT THESE PARAMETERS ####

# The game's name, as srcds calls it, e.g hl2mp
GAME="hl2mp"

# Set this to the AppID for the game you're using
# List can be found here: https://developer.valvesoftware.com/wiki/Steam_Application_IDs
APPID="232370"

# Set this to the map you want the server to load on launch.
MAP="dm_overwatch"

# Set this to the maximum number of slots you want the server to have.
MAXPLAYERS="16"

# Set this to the port that the server will run on.
PORT="27015"

# If you have multiple IPs and want to bind to one, enter it here.
# Otherwise, leave blank.
IP=""

# Set this to the location of your game folder
DIR="/home/ggo/gravitygunonly"

# Set this to your SteamCMD folder (the one that contains steamcmd.sh)
UPDATEDIR="/home/ggo/steamcmd"

# This variable sets the name of the GNU Screen session.
# Make sure that this is NOT the same as your UNIX username.
NAME="gravitygunonly"

# *OPTIONAL* If you have a web server on your server, enter a directory
# To store demo files for public download.
DEMODIR="/home/ggo/web/hl2mp/demos/"

# *OPTIONAL* If you are using a web server as shown above, enter the age
# in minutes you want to store demo files on your web server, e.g 10080
# is 1 week.
DEMOAGE="10080"

# If you get a message  on startup asking you to set the RSTDC_FREQUENCY
# Then set that value here, otherwise, leave the field blank.
RTDSC=""


######################################################################


####    STARTUP PARAMETERS    ####
#### DO NOT EDIT THIS SECTION ####

# Gathers a list of all process IDs relating to the server.
PID=$(pgrep -u $(whoami) -f "session=${NAME}" )

# Prints out the name of the running server.
INFO="${GAME} screen session '${NAME}'"

SCREENCMD="screen -mS ${NAME}"
ARGS="-console -game ${GAME} -port ${PORT} -maxplayers ${MAXPLAYERS} -ip ${IP} +map ${MAP}"
STARTCMD="${SCREENCMD} ./srcds_run ${ARGS}"

UPDATEARGS="+login anonymous +force_install_dir ${DIR} +app_update ${APPID} -beta prerelease validate +quit"
UPDATECMD="${SCREENCMD} ./steamcmd.sh ${UPDATEARGS}"


#######################################################################


####      SCRIPT ACTIONS      ####
#### DO NOT EDIT THIS SECTION ####

# the PATH line is only needed for if you run demo as a cronjob
# and even then it might just be FreeBSD that needs this.
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

startServer() {
	cd "$DIR"
  	export RDTSC_FREQUENCY='${RTDSC}'
	echo "Starting Server."
	${STARTCMD}
}

stopServer() {
	cd "$DIR"
	echo "Giving 10 second countdown warning."
	for i in {10..1}
	do
		echo -n "$i "
    	sendCommand "say The server is stopping in $i seconds."
        sleep 1
    done
	echo "Stopping Server."
	sendCommand quit
    while [[ `screen -ls |grep $NAME` ]]; do
      	sleep 1
    done
	echo "Server stopped."
}

restartServer() {
	cd "$DIR"
    echo "Giving 10 second countdown warning."
	for i in {10..1}
	do
		echo -n "$i "
		sendCommand "say The server is restarting in $i seconds."
		sleep 1
	done
    echo "Stopping Server."
	sendCommand quit
	while [[ `screen -ls |grep $NAME` ]]; do
		sleep 1
	done
	sleep 2
	startServer
}

updateServerRunning() {
	cd "$UPDATEDIR"
	echo "Giving 10 second countdown warning."
	for i in {10..1}
    do
    	echo -n "$i "
    	sendCommand "say The server is updating in $i seconds."
    	sleep 1
    done
	echo "Stopping Server."
	sendCommand quit
    while [[ `screen -ls |grep $NAME` ]]; do
    	sleep 1
    done
	sleep 2
	${UPDATECMD}
    while [[ `screen -ls |grep $NAME` ]]; do
        sleep 1
    done
	cd "$DIR"
	startServer
}

updateServerNotRunning() {
	echo "Updating Server."
	cd $UPDATEDIR
	${UPDATECMD}
    while [[ `screen -ls |grep $NAME` ]]; do
        sleep 1
    done
	echo "Update complete."
	cd "$DIR"
}

demo() {
	echo "Moving old demos to web server."
	#Moves all .dem files to the web server if they're older than 2 hours (to avoid cutting a demo short)
	find ${DIR}/${GAME}/ -iname "*.dem" -mmin +120 -exec chmod 664 {} \; -exec mv {} ${DEMODIR} \;

	#Delete all archived demo files older than period specified
	find ${DEMODIR} -name "*.dem" -mmin +${DEMOAGE} -exec rm {} \;
	echo "Move complete."
}

sendCommand() {
	local command=$(printf "$@\r")
	sh -c "screen -p0 -S "${NAME}" -X stuff \"${command}\""
}

####################################################################

case "$1" in
	start)
		if [[ ! `screen -ls |grep $NAME` ]]; then
			if [[ `type screen` ]]; then
				if [[ -e $DIR ]]; then
					if [[ -e $DIR/$GAME/maps/$MAP.bsp ]]; then
						echo "Starting ${INFO}"
						startServer
					else
						printf "$MAP is not in the maps folder, please choose a new map\n"
					fi
				else
					printf "${DIR} does not exist, please edit the DIR variable in the script\n"
				fi
			else
				printf "GNU Screen is not installed, please install it before continuing\n"
			fi
		else
            printf "Screen name ${NAME} is already in use\n"
            printf "Please either stop it or choose a new name\n"
		fi
	;;
	stop)
		if [[ `screen -ls |grep $NAME` ]]; then
			stopServer
		else
        	printf "${INFO} is not running, not stopping\n"
		fi
	;;
	restart)
        if [[ `screen -ls |grep $NAME` ]]; then
			restartServer
		else
			printf "${INFO} is not running. Not restarting.\n"
		fi
	;;
	update)
        if [[ `type screen` ]]; then
			if [[ -e $UPDATEDIR ]]; then
				if [[ `screen -ls |grep $NAME` ]]; then
       				printf "${INFO} is running. Warning, then stopping to update.\n"
           			updateServerRunning
				else
		            printf "${INFO} is not running. Updating anyway.\n"
		            updateServerNotRunning
				fi
			else
				printf "$UPDATEDIR doesn't exist. Please edit UPDATEDIR in the script\n"
			fi
		else
			printf "GNU Screen is not installed, please install it before continuing\n"
		fi
	;;
	demo)
		if [[ -e $DEMODIR ]]; then
			demo
		else
			printf "$DEMODIR does not exist, please edit DEMODIR in the script"
		fi
	;;
	*)
		printf "Usage: $0 {start|stop|restart|update|demo}\n"
		exit 2
	;;
esac
