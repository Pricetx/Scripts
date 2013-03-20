#!/usr/local/bin/bash
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
#####################################################################
# Gravity Gun Only bash script                                      #
# developed by Pricetx.                                             #
#                                                                   #
#####################################################################
#                                                                   #
# NOTE: To ensure that this script functions properly,              #
#       please make sure GNU Screen is installed.                   #
#  							                                        #
#	Also, if you're running Linux instead of *BSD then              #
#   you will need to change /usr/local/bin/bash to                  #
#	/bin/bash                                                       #
#								                                    #
#####################################################################

####    INGAME SETTINGS    ####
#### EDIT THESE PARAMETERS ####

# Sets the game to Half Life 2: Deathmatch, in normal use, DO NOT CHANGE THIS.
GAME="hl2mp"

# Set this to the map you want the server to load on launch.
MAP="dm_ob_killbox_gravity_gun"

# Set this to the maximum number of slots you want the server to have.
MAXPLAYERS="16"

# Set this to the port that the server will run on.
PORT="27017"

# If you have multiple IPs and want to bind to one, enter it here.
# Otherwise, leave blank.
IP=""


#######################################################################


####    SYSTEM SETTINGS    ####
#### EDIT THESE PARAMETERS ####


# Set this to the location of your orangebox folder.
DIR="/home/ggo/beta"

# Set this to the location to the folder up from your orangebox
# folder, i.e the folder that contains hldsupdatetool.bin
UPDATEDIR="/home/ggo/steamcmd"

# This variable sets the name of the GNU Screen session.
# Make sure that this is NOT the same as your UNIX username.
NAME="ggobeta"

# Set this to the location of your srcds_run script.
# This should NOT usually be changed.
BIN="./srcds_run"

# Set this to the location of your steam binary.
# This should NOT usually be changed.
UPDATEBIN="./steam.sh.freebsd"

# If you get a message  on startup asking you to set the RSTDC_FREQUENCY
# Then set that value here, otherwise, leave the field blank.
RTDSC=""

# *OPTIONAL* If you have a web server on your server, enter a directory
# To store demo files for public download.
DEMODIR="/home/ggo/web/hl2mp/demos/"

# *OPTIONAL* If you are using a web server as shown above, enter the age
# in minutes you want to store demo files on your web server, e.g 10080 
# is 1 week.
DEMOAGE="10080"


######################################################################


####    STARTUP PARAMETERS    ####
#### DO NOT EDIT THIS SECTION ####

# Gathers a list of all process IDs relating to the server.
PID=$(pgrep -u $(whoami) -f "session=${NAME}" )

# Prints out the name of the running server.
INFO="${GAME} screen session '${NAME}'"

SCREENCMD="screen -dmS ${NAME}"
ARGS="-Dsession=${NAME} -console -game ${GAME} -port ${PORT} -maxplayers ${MAXPLAYERS} -ip ${IP} +map ${MAP}"
STARTCMD="${SCREENCMD} ${BIN} ${ARGS}"


#######################################################################


####     UPDATE PARAMETERS    ####
#### DO NOT EDIT THIS SECTION ####

UPDATEARGS="+login anonymous +force_install_dir ../beta/ +app_update \"232370 -beta beta\" validate +quit"
UPDATECMD="${SCREENCMD} ${UPDATEBIN} ${UPDATEARGS}"


#######################################################################


####      SCRIPT ACTIONS      ####
#### DO NOT EDIT THIS SECTION ####


cd "$DIR"

startGGO() {
  	export RDTSC_FREQUENCY='${RTDSC}'
	echo "Starting Server."
	${STARTCMD}
	sleep 1
	screen -x ${NAME}
}

stopGGO() {
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

restartGGO() {
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
	startGGO
}

updateGGORunning() {
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
	sleep 2
	screen -x ${NAME}
        while [[ `screen -ls |grep $NAME` ]]; do
                sleep 1
        done
	cd "$DIR"
	startGGO
}

updateGGONotRunning() {
	echo "Updating Server."
	cd $UPDATEDIR
	${UPDATECMD}
	sleep 1
	screen -x ${NAME}
        while [[ `screen -ls |grep $NAME` ]]; do
                sleep 1
        done
	echo "Update complete."
}

demo() {
	echo "Moving old demos to web server."
	#Moves all .dem files to the web server if they're older than 2 hours (to avoid cutting a demo short)
	find ${DIR}/hl2mp/ -iname "*.dem" -mmin +120 -exec chmod 664 {} \; -exec mv {} ${DEMODIR} \;

	#Delete all archived demo files older than period specified
	find ${DEMODIR} -name "*.dem" -mmin +${DEMOAGE} -exec rm {} \;
	echo "Move complete."
}


sendCommand() {
	local command=$(printf "$@\r")
	sh -c "screen -p0 -S "${NAME}" -X stuff \"${command}\""
}

case "$1" in
	start)
		if [[ `screen -ls |grep $NAME` ]]; then
			printf "${INFO} already started with the following process ids \n${PID}\n"
		else
			echo "Starting ${INFO}"
			startGGO
		fi
	;;
	stop)
		if [[ `screen -ls |grep $NAME` ]]; then
			stopGGO
		else
                        printf "${INFO} is not running.\n"
		fi
	;;
	restart)
                if [[ `screen -ls |grep $NAME` ]]; then
			restartGGO
		else
			printf "${INFO} is not running. Not restarting.\n"
		fi
	;;
	update)
                if [[ `screen -ls |grep $NAME` ]]; then
			printf "${INFO} is running. Warning, then stopping to update.\n"
			updateGGORunning
		else
			printf "${INFO} is not running. Updating anyway.\n"
			updateGGONotRunning
		fi
	;;
        advert)
                if [[ `screen -ls |grep $NAME` ]]; then
                        advert
                else
                        printf "${INFO} is not running.\n"
                fi
        ;;
	demo)
		demo
	;;
	*)
		printf "Usage: $0 {start|stop|restart|update|demo}\n"
		exit 2
	;;
esac
