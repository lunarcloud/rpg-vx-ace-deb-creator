#!/usr/bin/env bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")/
GUI=true
source "$CURRENT_DIR"/script-dialog/script-dialog.sh #folder local version

relaunchIfNotVisible

APP_NAME="Game Launcher"
WINDOW_ICON="$CURRENT_DIR/game.png"

LICENSE="$CURRENT_DIR"LICENSE
APPDIR="$HOME"/.local/share/aoeu
LICENSE_ACCEPTED="$APPDIR"/LICENSE-accepted

mkdir -p "$APPDIR"

if [[ ! -f $LICENSE_ACCEPTED &&  -f $LICENSE ]]; then
    ACTIVITY="License"
    messagebox "You must accept the following license to use this software."
    displayFile "$CURRENT_DIR"/LICENSE
    yesno "Do you agree to and accept the license?";

    ANSWER=$?
    if [ $ANSWER -eq 0 ]; then
        touch "$LICENSE_ACCEPTED"
    else
		ACTIVITY="Declined"
        messagebox "Please uninstall this software or re-launch and accept the terms."
        exit 1;
    fi
fi

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    MKXP_SUPPORT=true
    LAUNCH="$CURRENT_DIR"$(find . -maxdepth 1 -name '*.amd64')
elif [ ${MACHINE_TYPE} == 'x86_64' ]; then
    MKXP_SUPPORT=true
    LAUNCH="$CURRENT_DIR"$(find . -maxdepth 1 -name '*x86')
else
    MKXP_SUPPORT=false
fi

if [[ ! -f $LAUNCH ]]; then
    echo "Application file not found";
    exit 2;
fi
if [[ ! -x $LAUNCH ]]; then
    echo "Application file does not have executable permission";
    exit 3;
fi

#detect wine
if [ $MKXP_SUPPORT == true ] ; then # no wine, only mkxp
	LD_LIBRARY_PATH="$CURRENT_DIR/lib" $LAUNCH
elif command -v wine 2>/dev/null; then # have wine
	wine "$CURRENT_DIR"Game.exe
else # neither wine nor mkxp
    ACTIVITY="Unable to launch"
    messagebox "Unable to launch on machine type $MACHINE_TYPE without wine installed";
fi

exit 0
