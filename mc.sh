#!/bin/sh
#-
#
# Copyright (c) 2013 Jonathan Price <jonathan@jonathanprice.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

# mc.sh
#
# Server managing script a Minecraft server using tmux. Includes
# commands to start, stop and restart the server, as well as connecting to
# the console
#
# Comments, suggestions, bug reports please to:
# Jonathan Price <jonathan@jonathanprice.org>
#
# NOTE: REQUIRES TMUX TO BE INSTALLED

# Name of tmux session
NAME="mc"

# Max memory (-Xmx)
MEM="800M"

# Location of minecraft jar file
DIR="/home/minecraft/minecraft/"

# Name of minecraft jar file
BIN="minecraft.jar"

# STARTUP PARAMTERS
# DO NOT EDIT THIS SECTION



# Shows the correct arguments to use this script
USAGE="Usage: $0 {start|stop|restart|stopnow|restartnow|console|status}"

# Determines whether there is a tmux server running
TMUXPID=$(pgrep -u "$(whoami)" -f "tmux" )

# Stores the directory the user was in when they ran the script
PWD=$(pwd)

# Is "stopping" or "restarting" based on command given
STATUS=""

# Sets the active server's settings
NAME=""
DIR=""
BIN=""
MEM=""



# FUNCTIONS
# DO NOT EDIT THIS SECTION



# Sets the Java startup arguments for the server, with personalised maximum heap size
setJavaParams() {
    JAVAPARAM="-Xmx${MEM} -jar"
}

# Starts the server, performing the following pre-startup checks:
# is tmux installed
# Does a tmux session with the same name already exist
# does the game folder $DIR exist
doStart() {
    if [ ! "$(command -v tmux)" ]; then
        echo "ERROR: tmux could not be found, is it installed?"
        exit 1
    fi

    if [ "$TMUXPID" ]; then
        if [ -n "$(tmux list-sessions | grep $NAME)" ]; then
            echo "ERROR: A tmux session with the name $NAME already exists"
            exit 1
        fi
    fi

    if [ ! -d $DIR ]; then
        echo "ERROR: Could not find $DIR. Is the path correct?"
        exit 1
    fi
    
    echo "Starting $1"
    setJavaParams
    cd $DIR
    tmux new-session -d -s $NAME "java $JAVAPARAM $BIN"
    tmux attach-session -t $NAME
    cd $PWD
}

# Stops the server, performing the following checks first
# Checks if tmux is running
# Checks if a tmux session with the correct name exists
doStop() {
    if [ ! "$TMUXPID" ]; then
        echo "ERROR: tmux is not running"
        exit 1
    fi

    if [ ! -n "$(tmux list-sessions | grep $NAME)" ]; then
        echo "ERROR: A tmux session with the name $NAME couldn't be found"
        exit 1
    fi
        
    echo "Giving 10 second countdown warning."
    
    tmux send-keys -t $NAME "save-all" ENTER
    
    for i in 10 9 8 7 6 5 4 3 2 1; do
        printf "%s " "$i"
        tmux send-keys -t $NAME "say The server is $STATUS in $i seconds." ENTER
        sleep 1
    done
    tmux send-keys -t $NAME "stop" ENTER
    tmux attach-session -t $NAME
    
    while [ -n "$(tmux list-session | grep $NAME)" ]; do
        sleep 1
    done
}

# Stops the server without warning, performing the following checks first
# Checks if tmux is running
# Checks if a tmux session with the correct name exists
doStopNow() {
    if [ ! "$TMUXPID" ]; then
        echo "ERROR: tmux is not running"
        exit 1
    fi

    if [ ! -n "$(tmux list-sessions | grep $NAME)" ]; then
        echo "ERROR: A tmux session with the name $NAME couldn't be found"
        exit 1
    fi
    
    tmux send-keys -t $NAME "save-all" ENTER
    sleep 1
    tmux send-keys -t $NAME "stop" ENTER
    tmux attach-session -t $NAME
    
    while [ -n "$(tmux list-session | grep $NAME)" ]; do
        sleep 1
    done
}

# Restarts the server. For checks, see stop and start functions.
doRestart() {
    doStop
    doStart
}

# Restarts the server without warning. For checks, see stop and start functions.
doRestartNow() {
    doStopNow
    doStart
}

# Attaches the user's shell into the tmux session.
doConsole() {
    tmux attach-session -t $NAME
}

# Returns some basic information about the server
doStatus() {
    echo "Game: Minecraft | tmux session: $NAME"
    if [ -n "$(tmux list-sessions | grep $NAME)" ]; then
        echo "Status: running"
    else
        echo "Status: not running"
    fi
}



# COMMAND INTERPRETER
# DO NOT EDIT THIS SECTION



if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments specified"
    echo "$USAGE"
    exit 2
elif [ -z "$1" ]; then
    echo "Missing {start|stop|restart|stopnow|restartnow|console|status}"
    echo "$USAGE"
    exit 2
fi

case $1 in
    start)
        doStart
    ;;
    stop)
        STATUS="stopping"
        doStop
    ;;
    restart)
        STATUS="restarting"
        doRestart
    ;;
    stopnow)
        doStopNow
    ;;
    restartnow)
        doRestartNow
    ;;
    console)
        doConsole
    ;;
    status)
        doStatus
    ;;
    *)
        echo "$2 does not exist."
        echo "$USAGE"
        exit 2
    ;;
esac
