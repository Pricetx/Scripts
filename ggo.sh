#!/usr/local/bin/bash
#####################################################################
# Gravity Gun Only bash script                                      #
# developed by Pricetx.                                             #
#                                                                   #
#####################################################################
#                                                                   #
# NOTE: To ensure that this script functions properly,              #
#       please make sure GNU Screen is installed.                   #
#								    #
#	Also, if you're running Linux instead of *BSD then          #
#       you will need to change /usr/local/bin/bash to              #
#	/bin/bash                                                   #
#								    #
#####################################################################

#### IN-GAME SETTINGS ####

# Sets the game to Half Life 2: Deathmatch, in normal use, DO NOT CHANGE THIS.
GAME="hl2mp"

# Set this to the map you want the server to load on launch.
MAP="dm_ob_killbox_gravity_gun"

# Set this to the maximum number of slots you want the server to have.
MAXPLAYERS="16"

# Set this to the port that the server will run on.
PORT="27015"

# If you have multiple IPs and want to bind to one, enter it here.
# Otherwise, leave blank.
IP=""


#######################################################################


####    SYSTEM SETTINGS    ####
#### EDIT THESE PARAMETERS ####


# Set this to the location of your orangebox folder.
DIR="/home/ggo/srcds/orangebox"

# Set this to the location to the folder up from your orangebox
# folder, i.e the folder that contains hldsupdatetool.bin
UPDATEDIR="/home/ggo/srcds"

# This variable sets the name of the GNU Screen session.
# Make sure that this is NOT the same as your UNIX username.
NAME="gravitygunonly"

# Set this to the location of your srcds_run script.
# This should NOT usually be changed.
BIN="./srcds_run"

# Set this to the location of your steam binary.
# This should NOT usually be changed.
UPDATEBIN="./steam"

# If you get a message  on startup asking you to set the RSTDC_FREQUENCY
# Then set that value here, otherwise, leave the field blank.
RTDSC=""


######################################################################


####   LIST OF FILES TO BACKUP   ####
#### TO AVOID UPDATE OVERWRITING ####

# Set this to the location you want to back up files to, so as not
# to get overwritten by an update
BACKUPDIR="/home/ggo/srcds/updatefiles"

# Name of the file (as seen in $BACKUPDIR)
BACKUP_1="game_sounds_manifest.txt"
# Full path to the file
BACKUPLOCATION_1="/home/ggo/srcds/orangebox/hl2/scripts/game_sounds_manifest.txt"

BACKUP_2="maplist.txt"
BACKUPLOCATION_2="/home/ggo/srcds/orangebox/hl2mp/maplist.txt"

BACKUP_3="valve.rc"
BACKUPLOCATION_3="/home/ggo/srcds/orangebox/hl2mp/cfg/valve.rc"


#######################################################################


####    STARTUP PARAMETERS    ####
#### DO NOT EDIT THIS SECTION ####

# Gathers a list of all process IDs relating to the server.
PID=$(pgrep -u $(whoami) -f "session=${NAME}" )

# Prints out the name of the running server.
INFO="${GAME} screen session '${NAME}'"

SCREENCMD="screen -dmS ${NAME}"
ARGS="-Dsession=${NAME} -console -game ${GAME} -port ${PORT} -maxplayers ${MAXPLAYERS} +map ${MAP} +ip ${IP}"
STARTCMD="${SCREENCMD} ${BIN} ${ARGS}"


#######################################################################


####     UPDATE PARAMETERS    ####
#### DO NOT EDIT THIS SECTION ####

UPDATEARGS="-command update -game ${GAME} -dir ."
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
                sendCommand "say Thankyou for playing on GravityGunOnly!"
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
		sendCommand "say Thankyou for your patience."
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
                sendCommand "say Thankyou for your patience."
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
	cd "$BACKUPDIR"
	echo "Copying '${BACKUP_1}' back"
	cp ${BACKUP_1} ${BACKUPLOCATION_1}
	echo "Copying '${BACKUP_2}' back"
	cp ${BACKUP_2} ${BACKUPLOCATION_2}
	echo "Copying '${BACKUP_3}' back"
	cp ${BACKUP_3} ${BACKUPLOCATION_3}
	sleep 2
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

advert() {
        echo "Starting Advertes."
        echo "NOTE: This script takes 30 minutes to run. It is recommended to run this as a cron job."
        sendCommand "say [NOTICE] Visit our website: www.gravitygunonly.com"
        sleep 180
        sendCommand "say [NOTICE] Bored of this map? type rtv in the chatbox."
        sleep 180
        sendCommand "say [NOTICE] The admins are: Pricetx, A-Lizzard-With-A-Fez"
        sleep 180
        sendCommand "say [NOTICE] View our stats page at www.gravitygunonly.com"
        sleep 180
        sendCommand "say [NOTICE] Suggest a map at www.gravitygunonly.com"
        sleep 180
        sendCommand "say [NOTICE] type motd to see a list of helpful commands."
        sleep 180
        sendCommand "say [NOTICE] View our forum thread at www.gravitygunonly.com"
        sleep 180
        sendCommand "say [NOTICE] type top10 to see the leaderboards."
        sleep 180
        sendCommand "say [NOTICE] Visit www.gravitygunonly.com for demo files of every match."
        sleep 180
        sendCommand "say [NOTICE] type motd to see the Message of the Day."
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
	*)
		printf "Usage: $0 {start|stop|restart|update|advert}\n"
		exit 2
	;;
esac
