#!/bin/ksh
#!/usr/local/bin/ksh
#
#  copy the images into the driver and vehicle imagekind directories
#

ProgPrefix=/Volumes/External300/DBProgs/RacePics
DestPrefix=/Volumes/Mirror3/ImageKind/SpeedWorld-ByVehicle
URLPrefix=http://photos.thefirst60feet.com/Transportation/Automobiles/Racing
PoolDir=/Volumes/Mirror3/ImageKind/SpeedWorld-ByDate
TableFile=/tmp/VehicleTable-car.$$
Today=`date +"%B %d, %Y"`

ImageCount=0

# is the target volume online?

if [ ! -f /Volumes/Mirror3/Present ]
then
  echo "Mirror3 not mounted, dipshit!!"
  exit
fi

#  Get the human names with no spaces

${ProgPrefix}/Human > /tmp/HumanFile.$$
exec 4</tmp/HumanFile.$$

while read -u4 HumanID HumanName
do

  echo "======${HumanName} ${HumanID}======"

  if [ ! -d ${DestPrefix}/${HumanName} ]
  then
    echo "  creating directory"
    mkdir ${DestPrefix}/${HumanName} >/dev/null 2>&1
  fi

  for Vehicle in `${ProgPrefix}/Query racepics "select num from vehicle where humanid = ${HumanID}"`
  do

    echo "  Vehicle ${Vehicle}"

    for Image in `${ProgPrefix}/Query racepics "select id from image where vehnum = '${Vehicle}'"`
    do

      find ${PoolDir} -name "${Image}*" -exec cp -p {} ${DestPrefix}/${HumanName} \;

    done  #  for each image

  done  #  for each vehicle

done  # for each space-removed human
exec 4<&-

#########################################################
##
##  now by vehicle number
##
#########################################################

echo ""

for Vehicle in `${ProgPrefix}/Query racepics "select num from vehicle"`
do

  echo "======${Vehicle}======"

  if [ ! -d ${DestPrefix}/${Vehicle} ]
  then
    echo "  Creating directory"
    mkdir ${DestPrefix}/${Vehicle} >/dev/null 2>&1
  fi

  for Image in `${ProgPrefix}/Query racepics "select id from image where vehnum = '${Vehicle}'"`
  do

    echo "  ${Image}"
    find ${PoolDir} -name "${Image}*" -exec cp -p {} ${DestPrefix}/${Vehicle} \;

  done  #  for each vehicle's image

done  #  for each vehicle




