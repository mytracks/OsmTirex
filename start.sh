#!/bin/sh

trap "echo TRAPed signal" HUP INT QUIT KILL TERM

if [ ! -f /osmstyles/shapefiles_loaded ]; then
  cd /osmstyles
  ./get-shapefiles.sh
  touch /osmstyles/shapefiles_loaded
fi

su -c 'tirex-master' gis
su -c 'tirex-backend-manager' gis
httpd

sleep infinity

# stop service and clean up here
killall httpd

echo "exited $0"
