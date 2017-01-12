#!/bin/ksh
##
##  script to create image related databases
##
##  creates the church DB from scratch
##  creates the race pics database from scratch
##  creates the affirmation database from scratch
##

##  turn on/off DBLoad profiling

DBProfile="Prof"  ##  turn on

##  initialize stuff

MyEMail="doug.greenwald@gmail.com"

PATH="${PATH}:."

ProgPrefix="/Volumes/External300/DBProgs/RacePics"

unset MYSQL
. /Volumes/External300/DBProgs/FSRServers/DougPerfData/SetDBCase.ksh

CREATERACE=./CreateRaceDB.ksh

WorkDir=`pwd`
InsertFile="${WorkDir}/CInserts.sql"
UpdateFile="${WorkDir}/CUpdates.sql"
if [ -f /Volumes/Space4/Present ]
then
  ImageDir="/Volumes/Space4/ChurchPhotography"
else
  ImageDir="/Volumes/External300/Volumes/Space4/ChurchPhotography"
fi
CDDir="/Volumes/External300/BurnImages/Churches"

if [ -f /Volumes/Space5/Present ]
then
  AffirmDir="/Volumes/Space5/ImageKind/Affirmations"
else
  AffirmDir="/Volumes/External300/Volumes/Space5/ImageKind/Affirmations"
fi

AffirmHTML="/Volumes/External300/DBProgs/RacePics/Affirmations.html"
AffirmHTML="/Volumes/External300/Sites/Daemony.com/Personal/PhotoCollections/Affirmations/Affirmations.html"

echo
echo
echo "Working from:"
echo "  $DBLocation"
echo "  $ImageDir"
echo "  $AffirmDir"
echo "  --> $CDDir"
echo "  $CREATERACE"
echo

echo "Making required executables..."

( cd $ProgPrefix ; make ) >/dev/null 2>&1

##
##  create the racepics database and tables
##

echo "Creating racepics database..."

$CREATERACE

##
##  create the church pics database and tables
##

echo "Creating church image tables..."

$MYSQL <<EOF

use racepics;

create table church (
id      int not null auto_increment primary key,
name    varchar(100) default 'NULL',
address varchar(100) default 'NULL',
city    varchar(50)  default 'NULL',
state   char(2)      default '00',
zip     varchar(10)  default 'NULL',
url     varchar(100) default 'NULL',
denom   varchar(50)  default 'NULL',
headimg varchar(30)  default 'NULL',
shortnm varchar(50)  default 'NULL'
)
engine = MyISAM
${DBdirClause}
;

create table cimage (
id      varchar(50) not null primary key,
church  int          default -1,
taken   date,
section enum('hdr', 'interior', 'exterior', 'grounds', 'fract')
)
engine = MyISAM
${DBdirClause}
;

create table chuman(
id      int not null auto_increment primary key,
church  int          default -1,
name    varchar(100) default 'NULL',
phone   varchar(25)  default 'NULL',
address varchar(100) default 'NULL',
city    varchar(50)  default 'NULL',
state   char(2)      default '00',
zip     varchar(10)  default 'NULL',
email   varchar(60)  default 'NULL'
)
engine = MyISAM
${DBdirClause}
;

##
##  populate tables
##

##  churches

insert into church (name, city, state, denom) values ('First Calvary Baptist Church', 'Leesville', 'SC', 'Baptist');
insert into church (name, city, state, denom) values ('Cedar Grove Evangelical Lutheran Church', 'Leesville', 'SC', 'Lutheran');
insert into church (name, city, state, denom) values ('Pilgrim Lutheran Church', 'Columbia', 'SC', 'Lutheran');
insert into church (name, city, state, denom) values ('Zion Lutheran Church', 'Lexington', 'SC', 'Lutheran');
insert into church (name, city, state, denom) values ('St. Michaels Lutheran Church', 'Columbia', 'SC', 'Lutheran');
insert into church (name, city, state, denom) values ('Life in Christ Lutheran Church', 'Peoria', 'AZ', 'Lutheran');
insert into church (name, city, state, denom) values ('Shiloh United Methodist Church', 'Gilbert', 'SC', 'Methodist');
insert into church (name, city, state, denom) values ('St. Stephens Lutheran Church', 'Lexington', 'SC', 'Lutheran');

##  people

insert into chuman (name, church, city, state) values ('Pastor George Spicer', 6, 'Peoria', 'AZ');


EOF

##
##  build the inserts for the images from the camera image directories
##

rm -f $InsertFile >/dev/null 2>&1
touch $InsertFile

echo
echo "Building church image inserts..."

##  Life in Christ Lutheran Church, Peoria, AZ

cd ${ImageDir}/00-LifeInChrist
ChurchName="Life in Christ Lutheran Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture life in christ lutheran peoria az arizona');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the Life in Christ Lutheran Church in Peoria, AZ.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture life in christ lutheran peoria az arizona redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the Life in Christ Lutheran Church in Peoria, AZ.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  First Calvary Baptist Church, Leesville, SC

cd ${ImageDir}/00-1rstCalvaryBaptist
ChurchName="First Calvary Baptist Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture first calvary baptist leesville sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the First Calvary Baptist Church in Leesville, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  # for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture first calvary baptist leesville sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the First Calvary Baptist Church in Leesville, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  Cedar Grove Lutheran Church, Leesville, SC

cd ${ImageDir}/00-CedarGroveLuth
ChurchName="Cedar Grove Evangelical Lutheran Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture cedar grove evangelical lutheran leesville sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the Cedar Grove Lutheran Church in Leesville, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture cedar grove evangelical lutheran leesville sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the Cedar Grove Lutheran Church in Leesville, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  Pilgrim Lutheran Chuch, Columbia, SC

cd ${ImageDir}/00-PilgrimLutheran
ChurchName="Pilgrim Lutheran Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture pilgrim lutheran columbia sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the Pilgrim Lutheran Church in Columbia, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture pilgrim lutheran columbia sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the Pilgrim Lutheran Church in Columbia, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  Shiloh United Methodist Church, Gilbert, SC

cd ${ImageDir}/00-ShilohUMethodist
ChurchName="Shiloh United Methodist Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture shiloh united methodist gilbert sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the Shiloh United Methodist Church in Gilbert, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture shiloh united methodist gilbert sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the Shiloh United Methodist Church in Gilbert, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  St Michael's Lutheran Church, Columbia, SC

cd ${ImageDir}/00-StMichaelsLutheran
ChurchName="St. Michaels Lutheran Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture st saint michaels lutheran columbia sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the St Michaels Lutheran Church in Columbia, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture st saint michaels lutheran columbia sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the St Michaels Lutheran Church in Columbia, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  Zion Lutheran Church, Lexington, SC

cd ${ImageDir}/00-ZionLutheran
ChurchName="Zion Lutheran Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture zion lutheran lexington sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the Zion Lutheran Church in Lexington, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file


if [ -d 00-FP ]
then
#  echo "    Zion has FP images"
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture zion lutheran lexington sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the Zion Lutheran Church in Lexington, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images

##  St. Stephen's Lutheran Church, Lexington, SC

cd ${ImageDir}/00-StStephensLutheran
ChurchName="St. Stephens Lutheran Church"
ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`

echo "  $ChurchName $ChurchNum"

for i in *.psd
do
  BaseName=`echo $i | awk -F \. '{ print $1 }'`
  echo "insert into cimage (id, church) values ('${BaseName}', ${ChurchNum});" >> $InsertFile
  echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture st saint stephens lutheran lexington sc south carolina');" >> $InsertFile
  echo "update keywords set descrip = 'Images of the St Stephens Lutheran Church in Lexington, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
done  ##  for each PSD file

if [ -d 00-FP ]
then
  cd 00-FP
  #for i in *.psd
  for i in `ls -l *.psd 2>/dev/null | awk '{ print $NF }'`
  do
    BaseName=`echo $i | awk -F \. '{ print $1 }'`
    echo "insert into cimage (id, church, section) values ('${BaseName}', ${ChurchNum}, 'fract');" >> $InsertFile
    echo "insert into keywords (id, words) values ('${BaseName}', 'church christian architecture st saint stephens lutheran lexington sc south carolina redfield plug in fractalius photomanipulation');" >> $InsertFile
    echo "update keywords set descrip = 'Images of the St Stephens Lutheran Church in Lexington, SC.  Photography by and Copyright Doug Greenwald, all rights reserved.' where id = '${BaseName}';" >> $InsertFile
  done  ##  for each PSD file
fi  ##  if there are FP images


##
##  insert the generated data
##

cd $WorkDir
$MYSQL <<EOF
use racepics;
source ${InsertFile};
EOF

##
##  create the Section90 files (the fractal processed files)
##

echo
echo "Creating Section90 files..."
exec 4<${WorkDir}/ChurchInfo
while read -u4 Dir ChurchName
do
  ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`
  NumImages=`${ProgPrefix}/NewQuery racepics "select count(*) from cimage where section = 'fract' and church = ${ChurchNum}"`
  echo "  $ChurchName $ChurchNum - $NumImages"
  # echo "    $NumImages"
  if [ $NumImages != 0 ]
  then
    echo "Fractal Art" > /Volumes/External300/BurnImages/Churches/$Dir/Section90
    # echo "    Creating /Volumes/External300/$Dir/Section90..."
    for FImage in `${ProgPrefix}/NewQuery racepics "select id from cimage where section = 'fract' and church = $ChurchNum"`
    do
      # echo "    $FImage"

      Caption="&nbsp;"
      DBCap=`NewQuery racepics "select caption from commerce where id = '$FImage'`
      if [ ! -z "$DBCap"  -a  "$DBCap" != "NULL" ]
      then
        echo "      caption override:  $DBCap"
        Caption=$DBCap
      fi
      echo "${FImage}.jpg $Caption" >> /Volumes/External300/BurnImages/Churches/$Dir/Section90
    done  ##  for each fractal image
  fi  ##  if we have fract images
done  ##  while reading ChurchInfo
exec 4<&-

##
##  now go through the CD images and update the images with their sections
##

echo
echo "Building church image section updates..."

exec 4<${WorkDir}/ChurchInfo
while read -u4 Dir ChurchName
do
  ChurchNum=`${ProgPrefix}/NewQuery racepics "select id from church where name = '${ChurchName}'"`
  echo "  $ChurchName $ChurchNum"

  #  if the CD image directory exists, process the section files

  if [ -d ${CDDir}/${Dir} ]
  then
#    echo "    CD image found"
    cd ${CDDir}/${Dir}
    for File in Section??
      do

#      echo "    $File"

      #  which section is this?

      Section=`head -1 $File | awk '{ print $1 }'`
      if [ "$Section" = "HDR" ]
      then
#        echo "      HDR images found"
        exec 5<${File}
        read -u5 Header
        while read -u5 Image Caption
        do
          BaseName=`echo $Image | awk -F \. '{ print $1 }'`
	  echo "update cimage set section = 'hdr' where id = '${BaseName}';" >> $UpdateFile
	  Doug1=`${ProgPrefix}/NewQuery racepics "select words from keywords where id = '${BaseName}'"`
	  KeyWords="$Doug1 hdr"
	  echo "update keywords set words = '${KeyWords}' where id = '${BaseName}';" >> $UpdateFile
        done  ##  while reading the file
        exec 5<&-
      elif [ "$Section" = "Interior" ]
      then
#        echo "      Interior images found"
        exec 5<${File}
        read -u5 Header
        while read -u5 Image Caption
        do
          BaseName=`echo $Image | awk -F \. '{ print $1 }'`
	  echo "update cimage set section = 'interior' where id = '${BaseName}';" >> $UpdateFile
	  Doug1=`${ProgPrefix}/NewQuery racepics "select words from keywords where id = '${BaseName}'"`
	  KeyWords="$Doug1 interior"
	  echo "update keywords set words = '${KeyWords}' where id = '${BaseName}';" >> $UpdateFile
        done  ##  while reading the file
        exec 5<&-
      elif [ "$Section" = "Exterior" ]
      then
#        echo "      Exterior images found"
        exec 5<${File}
        read -u5 Header
        while read -u5 Image Caption
        do
          BaseName=`echo $Image | awk -F \. '{ print $1 }'`
	  echo "update cimage set section = 'exterior' where id = '${BaseName}';" >> $UpdateFile
	  Doug1=`${ProgPrefix}/NewQuery racepics "select words from keywords where id = '${BaseName}'"`
	  KeyWords="$Doug1 exterior"
	  echo "update keywords set words = '${KeyWords}' where id = '${BaseName}';" >> $UpdateFile
        done  ##  while reading the file
        exec 5<&-
      elif [ "$Section" = "Grounds" ]
      then
#        echo "      Grounds images found"
        exec 5<${File}
        read -u5 Header
        while read -u5 Image Caption
        do
          BaseName=`echo $Image | awk -F \. '{ print $1 }'`
	  echo "update cimage set section = 'grounds' where id = '${BaseName}';" >> $UpdateFile
	  Doug1=`${ProgPrefix}/NewQuery racepics "select words from keywords where id = '${BaseName}'"`
	  KeyWords="$Doug1 grounds cemetary graveyard"
	  echo "update keywords set words = '${KeyWords}' where id = '${BaseName}';" >> $UpdateFile
        done  ##  while reading the file
        exec 5<&-
      elif [ "${Section}" = "Fractal" ]
      then
#        echo "    Fractal images found"
        exec 5<${File}
        read -u5 Header
        while read -u5 Image Caption
        do
          BaseName=`echo $Image | awk -F \. '{ print $1 }'`
	  Doug1=`${ProgPrefix}/NewQuery racepics "select words from keywords where id = '${BaseName}'"`
	  KeyWords="$Doug1 fractal processed photomanipulation redfield fractalius plug in"
	  echo "update keywords set words = '${KeyWords}' where id = '${BaseName}';" >> $UpdateFile
        done  ##  while reading the file
        exec 5<&-
      else
        echo "!!!!!!  UNKNOWN SECTION !!!!!!"
      fi
      
    done  ##  for each section file
  else  ##  if CD directory exists
    echo "    NO CD image"
  fi  ##  if CD directory exists

done  ##  while reading ChurchInfo
exec 4<&-

##
##  update the images with the date taken
##

echo
echo "Building church image taken updates..."

cd $WorkDir
exec 4<ChurchInfo
while read -u4 Dir ChurchName
do
  echo "  $ChurchName"

  if [ -d ${CDDir}/${Dir} ]
  then
    cd ${CDDir}/${Dir}/_FullSize
    #for File in D*.jpg
    for File in `ls -l D*.jpg 2>/dev/null | awk '{ print $NF }'`
    do
      BaseName=`echo $File | awk -F \. '{ print $1 }'`
      Taken=`jhead $File | grep Date\/Time | awk '{ print $3 }'`
#      echo "    $File $Taken"
      echo "update cimage set taken = '${Taken}' where id = '${BaseName}';" >> $UpdateFile
    done  ##  for each JPG
  else
    echo "    NO CD image"
  fi  ##  if the CD image exists

done  ##  while reading ChurchInfo
exec 4<&-

##
##  insert the generated data
##

cd $WorkDir
$MYSQL <<EOF
use racepics;
source ${UpdateFile};
EOF

##
##  update the short name of the church - the name used for the
##  web directory - no spaces or special chars
##

echo
echo "Updating short names..."

${MYSQL} <<EOF
use racepics;
update church set shortnm = 'SC-Leesville-FirstCalBaptist' where id = 1;
update church set shortnm = 'SC-Leesville-CedarGroveLutheran' where id = 2;
update church set shortnm = 'SC-Columbia-PilgrimLutheran' where id = 3;
update church set shortnm = 'SC-Gilbert-ShilohUMethodist' where id = 7;
update church set shortnm = 'SC-Columbia-StMichaelLutheran' where id = 5;
update church set shortnm = 'SC-Lexington-ZionLutheran' where id = 4;
update church set shortnm = 'AZ-Peoria-LICLutheran' where id = 6;
update church set shortnm = 'SC-Lexington-StStephensLutheran' where id = 8;
EOF

##
##  populate the church image pool from the CD image directories
##

echo
echo "Populating the chuch image pool..."

cd $WorkDir

exec 4<${WorkDir}/ChurchInfo
while read -u4 Dir ChurchName
do
  echo "  $ChurchName"

  if [ -d ${CDDir}/${Dir} ]
  then

    cd ${CDDir}/${Dir}/_Screen
    for File in *.jpg
      do
      cp -p $File /Volumes/External300/Churches/Screen/
    done  ##  for each JPG

    cd ${CDDir}/${Dir}/_Thumb
    for File in *.jpg
      do
      cp -p $File /Volumes/External300/Churches/Thumb/
    done  ##  for each JPG

  fi

done  ##  while reading churchinfo file
exec 4<&-

rm -f $InsertFile > /dev/null 2>&1
rm -f $UpdateFile > /dev/null 2>&1

##
##  create the Affirmations tables and populate
##

echo
echo "Creating Affirmations image tables..."

$MYSQL <<EOF

use racepics;

create table affirm (
id      int not null auto_increment primary key,
saying  int          default -1,      ##  FK to saying
image   varchar(60)  default 'NULL'   ##  the basename of the image
)
engine = MyISAM
${DBdirClause}
;

create table fonts (
id      int not null auto_increment primary key,
name    varchar(50) default 'NULL'    ##  name of font
)
engine = MyISAM
${DBdirClause}
;

create table saying (
id      int not null auto_increment primary key,
saying  varchar(512) default 'NULL',
type    enum ( 'love', 'rel', 'xmas', 'ween', 'invite', 'xxx'),
prefix  varchar(12)  default 'NULL'   ##  the image name prefix, tied to saying
)
engine = MyISAM
${DBdirClause}
;

create table aimage (
id      int not null auto_increment primary key,
prefix  varchar(12)  default 'NULL',
image   varchar(75)  default 'NULL',
fontnum int
)
engine = MyISAM
${DBdirClause}
;

##
##  assumes that the affirmation image has a specific name format
##
##    {PREFIX}_{IMAGE}_{FONTNUM}
##
##  which can be built from the database
##
##  gallery generation will be by saying and list the image and font
##  choices.  ultimately with font samples.
##

##
##  populate fonts table
##

insert into fonts (name) values ('Papyrus');                           ##    1
insert into fonts (name) values ('Dragonfly');                         ##    2
insert into fonts (name) values ('Love Letters');                      ##    3
insert into fonts (name) values ('Worstveld Sling Bold');              ##    4
insert into fonts (name) values ('TolkienUncialMF');                   ##    5
insert into fonts (name) values ('Radaern');                           ##    6
insert into fonts (name) values ('Penshurst');                         ##    7
insert into fonts (name) values ('Mouthful of Beer');                  ##    8
insert into fonts (name) values ('Lesser Concern');                    ##    9
insert into fonts (name) values ('Gisele Script');                     ##   10
insert into fonts (name) values ('Giddyup STD');                       ##   11
insert into fonts (name) values ('Erin Go Bragh');                     ##   12
insert into fonts (name) values ('Cretino');                           ##   13
insert into fonts (name) values ('Christmas Card');                    ##   14
insert into fonts (name) values ('ChopinScript');                      ##   15
insert into fonts (name) values ('CatholicSchoolGirls BB');            ##   16
insert into fonts (name) values ('Brin Athyn');                        ##   17
insert into fonts (name) values ('Bridgnorth');                        ##   18
insert into fonts (name) values ('Baroque Script');                    ##   19
insert into fonts (name) values ('Annabel Script');                    ##   20
insert into fonts (name) values ('A Charming Font Expanded');          ##   21
insert into fonts (name) values ('Apple Chancery');                    ##   22
insert into fonts (name) values ('XXII ARABIAN-ONENIGHTSTAND');        ##   23
insert into fonts (name) values ('Whoa!');                             ##   24
insert into fonts (name) values ('Teutonic No3');                      ##   25
insert into fonts (name) values ('Ruritania');                         ##   26
insert into fonts (name) values ('Medici Text');                       ##   27
insert into fonts (name) values ('Fiolex Girls');                      ##   28
insert into fonts (name) values ('Deliquent alt | Demo');              ##   29
insert into fonts (name) values ('cinnamon cake');                     ##   30
insert into fonts (name) values ('Bleeding Cowboys');                  ##   31
insert into fonts (name) values ('Angelic War');                       ##   32
insert into fonts (name) values ('A Yummy Apology');                   ##   33
insert into fonts (name) values ('Delta Hey Max Nine');                ##   34
insert into fonts (name) values ('HenryMorganHand');                   ##   35
insert into fonts (name) values ('AVQest');                            ##   36
insert into fonts (name) values ('Benegraphic');                       ##   37
insert into fonts (name) values ('Yoshitoshi');                        ##   38
insert into fonts (name) values ('Scriptina');                         ##   39
insert into fonts (name) values ('Santas Big Secret BB');              ##   40
insert into fonts (name) values ('Katy Berry');                        ##   41
insert into fonts (name) values ('Hobo Std');                          ##   42
insert into fonts (name) values ('Glastonbury Wide');                  ##   43
insert into fonts (name) values ('Cry Uncial');                        ##   44
insert into fonts (name) values ('Cabaletta');                         ##   45
insert into fonts (name) values ('Bickham Script Pro');                ##   46
insert into fonts (name) values ('Benighted');                         ##   47
insert into fonts (name) values ('AkashiMF');                          ##   48
insert into fonts (name) values ('Marker Felt');                       ##   49
insert into fonts (name) values ('Knights Templar');                   ##   50
insert into fonts (name) values ('Brush Script MT');                   ##   51
insert into fonts (name) values ('Deadly Breakfast');                  ##   52

#insert into fonts (name) values ('

##
##  populate sayings table
##

insert into saying (saying, prefix, type) values ('I will always see love when I look at you', 'SeeLove', 'love');
insert into saying (saying, prefix, type) values ('Your beauty glows from within with the radiance of your soul', 'BeautyGlows', 'love');
insert into saying (saying, prefix, type) values ('I am forever warm in your love', 'ForeverWarm', 'love');
insert into saying (saying, prefix, type) values ('I am Loved', 'Loved', 'love');
insert into saying (saying, prefix, type) values ('I am Strong', 'Strong', 'love');
insert into saying (saying, prefix, type) values ('I am Cherished', 'Cherished', 'love');
insert into saying (saying, prefix, type) values ('My promise to you...', 'MyPromise', 'love');
insert into saying (saying, prefix, type) values ('You are my partner and spiritual half.  I love you for the differences you bring to our similarities.', 'MyPartner', 'love');
insert into saying (saying, prefix, type) values ('Sailing into a golden future with you', 'Sailing', 'love');
insert into saying (saying, prefix, type) values ('You touch my heart and make my soul sigh with joy', 'SoulSigh', 'love');
insert into saying (saying, prefix, type) values ('Together we will make our lives better than they have ever been', 'Better', 'love');
insert into saying (saying, prefix, type) values ('You are everything my heart needs', 'Everything', 'love');
insert into saying (saying, prefix, type) values ('I see my future in the love in your eyes', 'Future', 'love');
insert into saying (saying, prefix, type) values ('You make my heart smile', 'HeartSmile', 'love');
insert into saying (saying, prefix, type) values ('I carry your laugh in my heart and I carry our love in my soul', 'Carry', 'love');
insert into saying (saying, prefix, type) values ('Your love is the fire in my heart that warms my soul', 'Fire', 'love');
insert into saying (saying, prefix, type) values ('Serenity', 'S', 'love');
insert into saying (saying, prefix, type) values ('Relax', 'R', 'love');
insert into saying (saying, prefix, type) values ('Breathe', 'B', 'love');

insert into saying (saying, prefix, type) values ('Peace', 'P', 'xmas');
insert into saying (saying, prefix, type) values ('Hope', 'H', 'xmas');
insert into saying (saying, prefix, type) values ('Love', 'L', 'xmas');
insert into saying (saying, prefix, type) values ('Joy', 'J', 'xmas');
insert into saying (saying, prefix, type) values ('Noel', 'N', 'xmas');
insert into saying (saying, prefix, type) values ('May your Holidays Glow', 'HG', 'xmas');
insert into saying (saying, prefix, type) values ('May your Holidays Shine', 'HS', 'xmas');
insert into saying (saying, prefix, type) values ('Happy Holidays', 'HH', 'xmas');
insert into saying (saying, prefix, type) values ('Merry Christmas', 'MC', 'xmas');
insert into saying (saying, prefix, type) values ('Seasons Greetings', 'SG', 'xmas');
insert into saying (saying, prefix, type) values ('Wishing You a Dark and Festive Christmas', 'DF', 'xmas');
insert into saying (saying, prefix, type) values ('Wishing You a Dark and Festive Holiday Season', 'DFH', 'xmas');
insert into saying (saying, prefix, type) values ('Wishing you a Holiday Season full of light', 'WHL', 'xmas');
insert into saying (saying, prefix, type) values ('Wishing you a Christmas full of light', 'WCL', 'xmas');

insert into saying (saying, prefix, type) values ('Wishing you Scary Things', 'ST', 'ween');
insert into saying (saying, prefix, type) values ('May all your frights come true', 'FT', 'ween');
insert into saying (saying, prefix, type) values ('Have a scary day', 'SD', 'ween');

insert into saying (saying, prefix, type) values ('Bathe me in Your waters and I am born again', 'BatheMe', 'rel');
insert into saying (saying, prefix, type) values ('I am home in Your house', 'Home', 'rel');

insert into saying (saying, prefix, type) values ('Forever Bound to Your Love', 'FBTYL', 'xxx');
insert into saying (saying, prefix, type) values ('Forever Bound to You', 'FBTY', 'xxx');
insert into saying (saying, prefix, type) values ('I Bind Myself to You', 'IBMTY', 'xxx');
insert into saying (saying, prefix, type) values ('Seasons Beatings', 'SB', 'xxx');
insert into saying (saying, prefix, type) values ('All Tha is Missing is You', 'ATIMIY', 'xxx');
insert into saying (saying, prefix, type) values ('I am Your Captive Valentine', 'IAYCV', 'xxx');
insert into saying (saying, prefix, type) values ('Be My Captive Valentine', 'BMCV', 'xxx');
insert into saying (saying, prefix, type) values ('You WILL be MY Valentine', 'YWBMV', 'xxx');
insert into saying (saying, prefix, type) values ('Missing You', 'MY', 'xxx');

insert into saying (saying, prefix, type) values ('Come and be Restrained', 'CABR', 'invite');
insert into saying (saying, prefix, type) values ('Private Party', 'PP', 'invite');
insert into saying (saying, prefix, type) values ('Youre Invited to a Hot Party', 'YITAHP', 'invite');

#insert into saying (saying, prefix, type) values ('

EOF

##
##  populate the aimage table from the existing affirmations
##

echo
echo "Populating available affirmations..."

rm -f $InsertFile > /dev/null 2>&1
rm -f $UpdateFile > /dev/null 2>&1

cd $AffirmDir

for File in *.psd
do
  FileBaseName=`echo $File | awk -F \. '{ print $1 }'`
  Prefix=`echo $FileBaseName | awk -F \_ '{ print $1 }'`
  Image=`echo $FileBaseName | awk -F \_ '{ print $2 }'`
  FontNum=`echo $FileBaseName | awk -F \_ '{ print $3 }'`
  #echo "  $Prefix -- $Image -- $FontNum"
  echo "insert into aimage (prefix, image, fontnum) values ('${Prefix}', '${Image}', $FontNum);" >> $InsertFile
done  ##  for each PSD file

##
##  insert the generated data
##

cd $WorkDir
$MYSQL <<EOF
use racepics;
source ${InsertFile};
EOF

##
##  create family images tables
##

$MYSQL <<EOF
use racepics;

create table fhuman (
pkey         int not null auto_increment,
fname        varchar(20),                  ##  first name
lname        varchar(30),                  ##  last name
email        varchar(50),                  ##  email address
fbook        varchar(50),                  ##  facebook page

primary key (pkey)
);

##
##  populate tables
##

insert into fhuman (fname, lname) values ('Edward', 'Greenwald');
insert into fhuman (fname, lname) values ('Anne', 'Greenwald');
insert into fhuman (fname, lname, email) values ('Doug', 'Greenwald', 'doug.greenwald@gmail.com');
insert into fhuman (fname, lname) values ('Ellen', 'Greenwald');
insert into fhuman (fname, lname) values ('Crystal', 'Merida');
insert into fhuman (fname, lname) values ('Paula', 'Coleman');
insert into fhuman (fname, lname) values ('Timothy', 'Price');
insert into fhuman (fname, lname) values ('Pablo', 'Merida');
insert into fhuman (fname) values ('James');
insert into fhuman (fname) values ('Daisey');
insert into fhuman (fname) values ('Ashley');
insert into fhuman (fname, lname) values ('Sophia', 'Merida');
insert into fhuman (fname, lname) values ('Lucy', 'Merida');
insert into fhuman (fname, lname) values ('Joshua', 'Coleman');
insert into fhuman (fname, lname) values ('Erica', 'Coleman');
insert into fhuman (fname, lname) values ('Eric', 'Coleman');
insert into fhuman (fname, lname) values ('Mikayla', 'Coleman');
insert into fhuman (fname, lname) values ('George', 'Coleman');
insert into fhuman (fname) values ('Jennie');
insert into fhuman (fname) values ('Ray');
insert into fhuman (fname, lname) values ('Frank', 'Popotnik');
insert into fhuman (fname, lname) values ('Dorothy', 'Popotnik');
insert into fhuman (fname, lname) values ('Frank', 'Popotnik');
insert into fhuman (fname, lname) values ('Gary', 'Popotnik');
insert into fhuman (fname, lname) values ('Joe', 'Kukec');
insert into fhuman (fname, lname) values ('Pat', 'Kukec');
insert into fhuman (fname) values ('Karen');
insert into fhuman (fname, lname) values ('Ken', 'Kukec');
insert into fhuman (fname, lname) values ('Joey', 'Kukec');
insert into fhuman (fname, lname) values ('Dan', 'Chachko');
insert into fhuman (fname, lname) values ('Laura', 'Chachko');
insert into fhuman (fname, lname) values ('Katie', 'Chachko');
insert into fhuman (fname, lname) values ('Kelsie', 'Chachko');
insert into fhuman (fname, lname) values ('Bill', 'Chachko');
insert into fhuman (fname, lname) values ('Jackie', 'Chachko');


EOF

##
##  clean up and go home
##

rm -f $InsertFile > /dev/null 2>&1
rm -f $UpdateFile > /dev/null 2>&1
