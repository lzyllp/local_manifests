#!/bin/bash

ROM_DIR='~/Rom/FULL/UNOFFICIAL'
ROM_TARGET_DIR='/FULL/UNOFFICIAL'

HOST='ftp.mokeedev.com'
UNAME='lzyllp'
PASSWRD='lzyllpuxt'

lockdir=/tmp/upload_lzyllp.lock

if ! mkdir "$lockdir" 2> /dev/null; then
	exit
fi

trap 'rm -rf "$lockdir"' 0

lftp -f "
open $HOST
user $UNAME $PASSWRD
mirror -R --use-cache --delete $ROM_DIR $ROM_TARGET_DIR
exit
"