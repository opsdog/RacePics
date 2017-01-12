#!/bin/ksh
##
##  script to test the return code of mysql if the DB isn't there
##

if [ -d /Volumes/External300/DBProgs/RacePics ]
then
  VIPDir=/Volumes/External300/DBProgs/RacePics
else
  VIPDir=/Users/douggreenwald/RacePics
fi

VIPDir=/tmp

LOCAL=false
REMOTE=false

##  echo "testing localhost..."
mysql -u doug -pILikeSex <<EOF >/dev/null 2>&1
use mysql;
EOF
##  echo "  --> $?"
if [ "$?" = "0" ]
then
  LOCAL=true
  echo "localhost"
  echo "localhost" > ${VIPDir}/DBvip
  exit
fi

##  echo "testing evildb..."
mysql -h evildb -u doug -pILikeSex <<EOF >/dev/null 2>&1
use mysql;
EOF
##  echo "  --> $?"
if [ "$?" = "0" ]
then
  REMOTE=true
  echo "evildb"
  echo "evildb" > /${VIPDir}/DBvip
  exit
fi

##  echo "testing big-mac..."
mysql -h big-mac -u doug -pILikeSex <<EOF >/dev/null 2>&1
use mysql;
EOF
##  echo "  --> $?"
if [ "$?" = "0" ]
then
  REMOTE=true
  echo "big-mac"
  echo "big-mac" > /${VIPDir}/DBvip
  exit
fi

echo "notfound"
echo "notfound" > /${VIPDir}/DBvip
