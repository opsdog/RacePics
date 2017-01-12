#!/bin/ksh
#!/usr/local/bin/ksh
#
#  script to generate who has images for a given date
#
#  first arg should be date in database fomat:  yyyy-mm-dd

if [ -z "$1" ]
then
  echo "Need a date, dipshit!!!"
  exit
fi

ProgPrefix=/Volumes/External300/DBProgs/RacePics

#  clear files from old runs

rm -f dougee.? >/dev/null 2>&1

#  get vehicles that have images from the given date

${ProgPrefix}/NewQuery racepics "select distinct vehnum from image where taken = '$1'" > dougee.1

touch dougee.2
exec 4<dougee.1
while read -u4 Vehicle
do
  ${ProgPrefix}/NewQuery racepics "select human.name from human, vehicle where vehicle.num = '$Vehicle' and human.id = vehicle.humanid" >> dougee.2
done
exec 4<&-

sort -u dougee.2