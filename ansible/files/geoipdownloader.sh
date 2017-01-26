#! /bin/bash

# variables
CURRENT_DIR="$(cd "$(dirname "$0")"; pwd)"
# in case the location changes generally change the pre-defined location...
OLD_FILE="/usr/share/GeoIP/GeoLite2-City.mmdb"
NEW_FILE=$OLD_FILE

# check for optional parameter
if [ -z "$1" ]
  then
    echo "No targetfile supplied, /usr/share/GeoIP/GeoLite2-City.mmdb will be used!"
    NEW_FILE=/usr/share/GeoIP/GeoLite2-City.mmdb
fi

# download to /tmp
cd /tmp
# cleanup /tmp from GeoIP artefacts
rm -rf GeoLite2-City*

# getting the database
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz 
if [ $? <> 0 ]; then
     echo "Download failed..."
     exit 1
fi

# deflate to TARGET_FILE
gunzip GeoLite2-City.mmdb.gz
if [ $? <> 0 ]; then
     echo "gunzip failed due to unknown reason..."
     exit 1
fi

MOV_DATE=`date +"%Y-%m-%d"`
mv $OLD_FILE $OLD_FILE.$MOD_DATE && mv /tmp/GeoLite2-City.mmdb $NEW_FILE
if [ $? <> 0 ]; then
     echo "moving GeoIP database failed..."
     exit 1
fi

cd $CURRENT_DIR
