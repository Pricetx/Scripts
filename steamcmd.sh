#!/usr/local/bin/bash
# SteamCMD script for FreeBSD

STEAMROOT=$(cd "${0%/*}" && echo $PWD)
STEAMEXE=steamcmd
PLATFORM=linux32
export LD_LIBRARY_PATH="${STEAMROOT}"/${PLATFORM}:$LD_LIBRARY_PATH
PATHLINK=~/.steampath
rm -f ${PATHLINK} && ln -s ${STEAMROOT}/${PLATFORM}/${STEAMEXE} 
${PATHLINK}
PIDFILE=~/.steampid
echo $$ > ~/.steampid

ulimit -n 2048

# and launch steam
cd "$STEAMROOT"
STATUS=42
while [ $STATUS -eq 42 ]; do
${DEBUGGER} "${STEAMROOT}"/${PLATFORM}/${STEAMEXE} "$@"
STATUS=$?
done
exit $STATUS
