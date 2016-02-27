#!/bin/sh

trap "echo TRAPed signal" HUP INT QUIT KILL TERM

su -c 'tirex-master' gis
su -c 'tirex-backend-manager' gis
httpd

sleep infinity

# stop service and clean up here
killall httpd

echo "exited $0"
