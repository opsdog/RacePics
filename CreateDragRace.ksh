#!/bin/ksh
##
##  script to create the drag racing galleries
##
##  will populate the correct directory structure of TheFirst60Feet.com
##

##  initialize stuff

Today=`date +"%B %d, %Y"`

MyEMail="doug.greenwald@gmail.com"

PATH="${PATH}:."

ProgPrefix="/Volumes/External300/DBProgs/RacePics"

unset MYSQL
. /Volumes/External300/DBProgs/FSRServers/DougPerfData/SetDBCase.ksh

WorkDir=`pwd`

##  web stuff

SitePath=/Volumes/External300/Sites/TheFirst60Feet.com
SiteURL=http://www.thefirst60feet.com

echo
echo
echo "CreateDragRace.ksh working from:"
echo "  DB:        $DBLocation"
echo "  Progs:     $ProgPrefix"
echo "  Site path: $SitePath"
echo "  Site URL:  $SiteURL"
echo

echo "Making required executables..."

( cd $ProgPrefix ; make ) >/dev/null 2>&1

##
##  outer loop on venue
##

echo
echo "Creating by Venue..."

for Venue in `${ProgPrefix}/NewQuery racepics "select distinct venue from event where class = 'race' and subclass = 'drag' order by venue"`
do

  ##
  ##  build the specific Path and URL info for this event
  ##

  case $Venue in

    'SW' )  VenuePath="speedworld"
	    VenueName="SpeedWorld Raceway Park"
	    ;;

    * )     echo "Unknown venue $Venue"
            exit
	    ;;

  esac

  FullSiteURL="${SiteURL}/${VenuePath}"
  FullBasePath="${SitePath}/${VenuePath}"
  FullGalleryPath="${SitePath}/${VenuePath}/Galleries"

  echo
  echo "    $FullSiteURL"
  echo "    $FullBasePath"
  echo "    $FullGalleryPath"
  echo

  cat > ${SitePath}/${VenuePath}/index.html <<EOF
<html>
<head>

<title>Drag Racing pics from $VenueName</title>

<link rel=stylesheet href="http://www.thefirst60feet.com/Styles/DragRace.css" type="text/css">

<meta name="description" content="Photographs of drag racing at ${VenueName}.  Photography by and copyright Douglas Greenwald, all rights reserved." />
<meta name="keywords" content="doug, greenwald, photography, ${VenueName}, drag, racing, dragster, motorcycle, car, automobile, race, motorsport, picture, image, photograph, NHRA, bike, pictures, photographs, junior, dragster" />
<meta name="revision" content="${Today}" />

</head>
<body>
<h1 align=center>Pictures taken at ${VenueName}</h1>

<p>Images I have taken at ${VenueName}. These images are grouped by date they were taken and by vehicle that is the primary subject of the photo. Where possible I have identified the vehicle by owner/driver/number.</p>

<p>Please see the listing of "Unknown" vehicles if your vehicle is pictured in a gallery by date but you do not see your name or vehicle number below. Please <a href="mailto:doug.greenwald@gmail.com">email me</a> to have your vehicle correctly identified.</p>

<p>Questions, comments, and/or rude remarks, to <a href="mailto:doug.greenwald@gmail.com">doug.greenwald@gmail.com</a>.</p>

<h2>Images by Date:</h2>
EOF

  ##
  ##  get the drag race events for this venue
  ##

  ${ProgPrefix}/NewQuery racepics "select pkey, held from event where class = 'race' and subclass = 'drag' and venue = '${Venue}' order by held" > tmp_dragraces
  ## ${ProgPrefix}/NewQuery racepics "select pkey, held from event where class = 'race' and subclass = 'drag' and venue = '${Venue}' order by held limit 2" > tmp_dragraces  ##  for testing

  exec 4<tmp_dragraces
  while read -u4 pkey held
  do
    echo "  $held $pkey"

    EventDescrip=`${ProgPrefix}/NewQuery racepics "select descrip from event where pkey = $pkey`
    EventKeywords=`${ProgPrefix}/NewQuery racepics "select keywords from event where pkey = $pkey`
    EventWebText=`${ProgPrefix}/NewQuery racepics "select webtext from event where pkey = $pkey`

    ##
    ##  add this event's link to the main venue page
    ##

    echo "<p><a href="${FullSiteURL}/Galleries/${held}/">${held}</a> - ${EventDescrip}</p>" >> ${FullBasePath}/index.html

    ##
    ##  create the venue's date specific gallery 
    ##
    ##  start the date gallery index.html
    ##

    if [ ! -d ${FullGalleryPath}/${held} ]
    then
      mkdir ${FullGalleryPath}/${held}
    fi

    ##  create the Info file

    echo "${EventDescrip}" > ${FullGalleryPath}/${held}/Info
    echo "${EventDescrip}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${FullGalleryPath}/${held}/Info
    echo "${EventKeywords}" >> ${FullGalleryPath}/${held}/Info
    echo "${EventWebText}" >> ${FullGalleryPath}/${held}/Info

    ##
    ##  get the image id's for this event
    ##

    ${ProgPrefix}/NewQuery racepics "select id from image where section = 'main' and eventid = $pkey" > tmp_imageids_main
    ${ProgPrefix}/NewQuery racepics "select id from image where section = 'junior' and eventid = $pkey" > tmp_imageids_junior
    ${ProgPrefix}/NewQuery racepics "select id from image where section = 'special' and eventid = $pkey" > tmp_imageids_spec
    ${ProgPrefix}/NewQuery racepics "select id from image where section = 'show' and eventid = $pkey" > tmp_imageids_show

    NumMain=`wc -l tmp_imageids_main | awk '{ print $1 }'`
    NumJunior=`wc -l tmp_imageids_junior | awk '{ print $1 }'`
    NumSpecial=`wc -l tmp_imageids_spec | awk '{ print $1 }'`
    NumShow=`wc -l tmp_imageids_show | awk '{ print $1 }'`

    echo "    Found $NumMain for Main"
    echo "    Found $NumJunior for Junior"
    echo "    Found $NumSpecial for Special"
    echo "    Found $NumShow for Show"

    ##
    ##  the idea here is to build section files from the images found
    ##  build an Info file from the description
    ##  then run a CreateIndex.html to create the gallery
    ##

    rm -f ${FullGalleryPath}/${held}/ImagesMissing 2>/dev/null

    if [ $NumMain != 0 ]
    then
      echo "    Creating Section10 (Main) file..."
      echo "Cars" > ${FullGalleryPath}/${held}/Section10
      for loopImage in `${ProgPrefix}/NewQuery racepics "select id from image where eventid = $pkey and section = 'main' order by id"`
      do
        ## echo "${loopImage}.jpg &nbsp;" >> ${FullGalleryPath}/${held}/Section10
	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${loopImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${FullGalleryPath}/${held}/Section10
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${FullGalleryPath}/${held}/ImagesMissing
	fi  ##  if null ImageFile
      done  ##  for each loopImage
    fi

    if [ $NumJunior != 0 ]
    then
      echo "    Creating Section20 (Juniors) file..."
      echo "Juniors" > ${FullGalleryPath}/${held}/Section20
      for loopImage in `${ProgPrefix}/NewQuery racepics "select id from image where eventid = $pkey and section = 'junior' order by id" `
      do
	## echo "${loopImage}.jpg &nbsp;" >> ${FullGalleryPath}/${held}/Section20
	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${loopImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${FullGalleryPath}/${held}/Section20
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${FullGalleryPath}/${held}/ImagesMissing
	fi  ##  if null ImageFile
      done
    fi

    if [ $NumSpecial -ne 0 ]
    then
      echo "    Creating Section30 (Special) file..."
      echo "Special Event" > ${FullGalleryPath}/${held}/Section30
      for loopImage in `${ProgPrefix}/NewQuery racepics "select id from image where eventid = $pkey and section = 'special' order by id"`
      do
	## echo "${loopImage}.jpg &nbsp;" >> ${FullGalleryPath}/${held}/Section30
	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${loopImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${FullGalleryPath}/${held}/Section30
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${FullGalleryPath}/${held}/ImagesMissing
	fi  ##  if null ImageFile
      done
    fi

    if [ $NumShow -ne 0 ]
    then
      echo "    Creating Section40 (Show) file..."
      echo "Car Show" > ${FullGalleryPath}/${held}/Section40
      for loopImage in `${ProgPrefix}/NewQuery racepics "select id from image where eventid = $pkey and section = 'show' order by id"`
      do
	## echo "${loopImage}.jpg &nbsp;" >> ${FullGalleryPath}/${held}/Section40
	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${loopImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${FullGalleryPath}/${held}/Section40
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${FullGalleryPath}/${held}/ImagesMissing
	fi  ##  if null ImageFile
      done
    fi

    ##  create the venue/data specific index.html

    if [ -f ${FullGalleryPath}/${held}/CreateIndex.ksh ]
    then
      rm -f ${FullGalleryPath}/${held}/CreateIndex.ksh 2>/dev/null
    fi
    cp Prototypes/CreateDRDateIndex.ksh ${FullGalleryPath}/${held}/CreateIndex.ksh

    echo "    Creating index"

    ( cd ${FullGalleryPath}/${held} ; ./CreateIndex.ksh $VenuePath >/dev/null 2>&1 )


  done  ##  while reading tmp_dragraces
  exec 4<&-

  #########################################################################
  #########################################################################
  ##
  ##  get the cars br driver
  ##
  #########################################################################
  #########################################################################


  echo
  echo "Generating images by human..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Cars by Owner/Driver:</h2>" >> ${FullBasePath}/index.html

  ##  get the drag race driver names

  if [ ! -d ${FullGalleryPath}/ByDriver ]
  then
    mkdir ${FullGalleryPath}/ByDriver 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByDriver"
      echo ; echo
      exit
    fi
  fi

  ImageCount=0
  echo "<div align="center">">> ${SitePath}/${VenuePath}/index.html
  echo "<table cellspacing=15 cellpadding=3 border=0>">> ${SitePath}/${VenuePath}/index.html
  echo "<tr>">> ${SitePath}/${VenuePath}/index.html


  for DriverID in `${ProgPrefix}/NewQuery racepics "select id from human where id in (select humanid from vehicle where num in (select distinct vehnum from image where id in (select id from image where eventid in (select pkey from event where venue = '${Venue}')))) order by name"`
  ## for DriverID in `${ProgPrefix}/NewQuery racepics "select id from human where id in (select humanid from vehicle where num in (select distinct vehnum from image where id in (select id from image where eventid in (select pkey from event where venue = '${Venue}')))) order by name limit 11"`  ##  for testing
  do
    DriverName=`${ProgPrefix}/NewQuery racepics "select name from human where id = $DriverID"`
    echo "  $DriverName ($DriverID)"

    ##
    ##  create the human directory
    ##  create the driver specific files
    ##  create the entry in the top-level index
    ##

    DriverGalleryPath=${FullGalleryPath}/ByDriver/$DriverID

    if [ ! -d ${DriverGalleryPath} ]
    then
      mkdir ${DriverGalleryPath} 2>/dev/null
      if [ $? != 0 ]
      then
	echo ; echo
	echo "Failed to create ${DriverGalleryPath}"
	echo ; echo
	exit
      fi
    fi

    ##  create the driver specfic Info file

    echo "$DriverName" > ${DriverGalleryPath}/Info
    echo "${DriverName}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${DriverGalleryPath}/Info
    echo "NHRA, drap, race, racing auto, automobile, car, photo, photography" >> ${DriverGalleryPath}/Info
    echo "&nbsp;" >> ${DriverGalleryPath}/Info

    cp Prototypes/CreateDRDriverIndex.ksh ${DriverGalleryPath}/CreateIndex.ksh

    ##  only 1 section for a driver gallery

    echo "$DriverName" > ${DriverGalleryPath}/Section10
    for DriverVehicle in `${ProgPrefix}/NewQuery racepics "select num from vehicle where humanid = $DriverID order by num"`
    do
      echo "    Vehicle:  $DriverVehicle"
      for DriverImage in `${ProgPrefix}/NewQuery racepics "select id from image where vehnum = '$DriverVehicle' order by id"`
      do
	## echo "${DriverImage}.jpg &nbsp" >> ${DriverGalleryPath}/Section10

	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${DriverImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${DriverGalleryPath}/Section10
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${DriverGalleryPath}/ImagesMissing
	fi  ##  if null ImageFile

      done  ##  for each driver's image
    done  ##  for each driver's vehicle

    ##  create the driver index

    ( cd $DriverGalleryPath ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 

    ##  add to main venue index.html

    if [ "$ImageCount" = "4" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByDriver/${DriverID}/\">${DriverName}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      echo "</tr>" >> ${SitePath}/${VenuePath}/index.html
      echo "" >> ${SitePath}/${VenuePath}/index.html
      echo "<tr>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=5
    fi  #  if ImageCount is 4

    if [ "$ImageCount" = "3" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByDriver/${DriverID}/\">${DriverName}</a></td>" >> ${SitePath}/${VenuePath}/index.html
     ImageCount=4
    fi

    if [ "$ImageCount" = "2" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByDriver/${DriverID}/\">${DriverName}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=3
    fi

    if [ "$ImageCount" = "1" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByDriver/${DriverID}/\">${DriverName}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=2
    fi

    if [ "$ImageCount" = "0" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByDriver/${DriverID}/\">${DriverName}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=1
    fi

    if [ "$ImageCount" = "5" ]
    then
      ImageCount=0
    fi

  done  ##  for each DriverID

  ##  end the human table

  if [ "$ImageCount" = "0" ]
  then
    echo "<td colspan=5>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "1" ]
  then
    echo "<td colspan=4>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "2" ]
  then
    echo "<td colspan=3>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "3" ]
  then
    echo "<td colspan=2>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "4" ]
  then
    echo "<td colspan=1>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  echo "</table>">> ${SitePath}/${VenuePath}/index.html
  echo "</div>">> ${SitePath}/${VenuePath}/index.html

  #########################################################################
  #########################################################################
  ##
  ##  get the car NHRA numbers
  ##
  #########################################################################
  #########################################################################

  echo
  echo "Generating images by car number..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Cars by NHRA Number:</h2>" >> ${FullBasePath}/index.html

  if [ ! -d ${FullGalleryPath}/ByCarNum ]
  then
    mkdir ${FullGalleryPath}/ByCarNum 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByCarNum"
      echo ; echo
      exit
    fi
  fi

  ImageCount=0
  echo "<div align="center">">> ${SitePath}/${VenuePath}/index.html
  echo "<table cellspacing=15 cellpadding=3 border=0>">> ${SitePath}/${VenuePath}/index.html
  echo "<tr>">> ${SitePath}/${VenuePath}/index.html

  for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select num from vehicle where type = 'car' order by num"`
  ## for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select num from vehicle where type = 'car' order by num limit 11"`  ##  for testing
  do
    echo "  $VehicleNumber"

    VehicleGalleryPath=${FullGalleryPath}/ByCarNum/$VehicleNumber

    if [ ! -d ${VehicleGalleryPath} ]
    then
      mkdir ${VehicleGalleryPath} 2>/dev/null
      if [ $? != 0 ]
      then
	echo ; echo
	echo "Failed to create ${VehicleGalleryPath}"
	echo ; echo
	exit
      fi
    fi

    ##  create the vehicle specific Info file

    echo "$VehicleNumber" > ${VehicleGalleryPath}/Info
    echo "${VehicleNumber}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${VehicleGalleryPath}/Info
    echo "NHRA, drag, race, racing, auto, automobile, car, photo, photography" >> ${VehicleGalleryPath}/Info
    echo "&nbsp;" >> ${VehicleGalleryPath}/Info

    cp Prototypes/CreateDRDriverIndex.ksh ${VehicleGalleryPath}/CreateIndex.ksh

    ##  only 1 section for a vehicle gallery

    echo "$VehicleNumber" > ${VehicleGalleryPath}/Section10
    for VehicleImage in `${ProgPrefix}/NewQuery racepics "select distinct id from image where vehnum = '${VehicleNumber}' order by id"`
    do
      ## echo "    $VehicleImage"
      ## echo "${VehicleImage}.jpg &nbsp;" >> ${VehicleGalleryPath}/Section10

      unset ImageFile
      for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${VehicleImage}* 2>/dev/null | awk '{ print $NF }'`
      do
        echo "`basename ${ImageFile}` &nbsp;" >> ${VehicleGalleryPath}/Section10
      done  ##  for each ImageFile
      if [ -z "$ImageFile" ]
      then
	echo "$loopImage" >> ${VehicleGalleryPath}/ImagesMissing
      fi  ##  if null ImageFile

    done  ##  for each vehicle image

    ##  create the vehicle index

    ( cd $VehicleGalleryPath ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 

    ##  add to main venue index.html

    if [ "$ImageCount" = "4" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByCarNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      echo "</tr>" >> ${SitePath}/${VenuePath}/index.html
      echo "" >> ${SitePath}/${VenuePath}/index.html
      echo "<tr>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=5
    fi  #  if ImageCount is 4

    if [ "$ImageCount" = "3" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByCarNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
     ImageCount=4
    fi

    if [ "$ImageCount" = "2" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByCarNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=3
    fi

    if [ "$ImageCount" = "1" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByCarNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=2
    fi

    if [ "$ImageCount" = "0" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByCarNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=1
    fi

    if [ "$ImageCount" = "5" ]
    then
      ImageCount=0
    fi

  done  ##  for each VehicleNumber

  ## end the vehicle table

  if [ "$ImageCount" = "0" ]
  then
    echo "<td colspan=5>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "1" ]
  then
    echo "<td colspan=4>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "2" ]
  then
    echo "<td colspan=3>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "3" ]
  then
    echo "<td colspan=2>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "4" ]
  then
    echo "<td colspan=1>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  echo "</table>">> ${SitePath}/${VenuePath}/index.html
  echo "</div>">> ${SitePath}/${VenuePath}/index.html

  #########################################################################
  #########################################################################
  ##
  ##  get the bike NHRA numbers
  ##
  #########################################################################
  #########################################################################

  echo
  echo "Generating images by bike number..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Bike by NHRA Number:</h2>" >> ${FullBasePath}/index.html

  if [ ! -d ${FullGalleryPath}/ByBikeNum ]
  then
    mkdir ${FullGalleryPath}/ByBikeNum 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByBikeNum"
      echo ; echo
      exit
    fi
  fi

  ImageCount=0
  echo "<div align="center">">> ${SitePath}/${VenuePath}/index.html
  echo "<table cellspacing=15 cellpadding=3 border=0>">> ${SitePath}/${VenuePath}/index.html
  echo "<tr>">> ${SitePath}/${VenuePath}/index.html

  for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select num from vehicle where type = 'bike' order by num"`
  ## for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select num from vehicle where type = 'bike' order by num limit 11"`  ##  for testing
  do
    echo "  $VehicleNumber"

    VehicleGalleryPath=${FullGalleryPath}/ByBikeNum/$VehicleNumber

    if [ ! -d ${VehicleGalleryPath} ]
    then
      mkdir ${VehicleGalleryPath} 2>/dev/null
      if [ $? != 0 ]
      then
	echo ; echo
	echo "Failed to create ${VehicleGalleryPath}"
	echo ; echo
	exit
      fi
    fi

    ##  create the vehicle specific Info file

    echo "$VehicleNumber" > ${VehicleGalleryPath}/Info
    echo "${VehicleNumber}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${VehicleGalleryPath}/Info
    echo "NHRA, drag, race, racing, auto, automobile, car, photo, photography" >> ${VehicleGalleryPath}/Info
    echo "&nbsp;" >> ${VehicleGalleryPath}/Info

    cp Prototypes/CreateDRDriverIndex.ksh ${VehicleGalleryPath}/CreateIndex.ksh

    ##  only 1 section for a vehicle gallery

    echo "$VehicleNumber" > ${VehicleGalleryPath}/Section10
    for VehicleImage in `${ProgPrefix}/NewQuery racepics "select distinct id from image where vehnum = '${VehicleNumber}' order by id"`
    do
      ## echo "    $VehicleImage"
      ## echo "${VehicleImage}.jpg &nbsp;" >> ${VehicleGalleryPath}/Section10

      unset ImageFile
      for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${VehicleImage}* 2>/dev/null | awk '{ print $NF }'`
      do
        echo "`basename ${ImageFile}` &nbsp;" >> ${VehicleGalleryPath}/Section10
      done  ##  for each ImageFile
      if [ -z "$ImageFile" ]
      then
	echo "$loopImage" >> ${VehicleGalleryPath}/ImagesMissing
      fi  ##  if null ImageFile

    done  ##  for each vehicle image

    ##  create the vehicle index

    ( cd $VehicleGalleryPath ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 

    ##  add to main venue index.html

    if [ "$ImageCount" = "4" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByBikeNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      echo "</tr>" >> ${SitePath}/${VenuePath}/index.html
      echo "" >> ${SitePath}/${VenuePath}/index.html
      echo "<tr>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=5
    fi  #  if ImageCount is 4

    if [ "$ImageCount" = "3" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByBikeNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
     ImageCount=4
    fi

    if [ "$ImageCount" = "2" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByBikeNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=3
    fi

    if [ "$ImageCount" = "1" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByBikeNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=2
    fi

    if [ "$ImageCount" = "0" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByBikeNum/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=1
    fi

    if [ "$ImageCount" = "5" ]
    then
      ImageCount=0
    fi

  done  ##  for each VehicleNumber

  ##  end the bike table

  if [ "$ImageCount" = "0" ]
  then
    echo "<td colspan=5>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "1" ]
  then
    echo "<td colspan=4>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "2" ]
  then
    echo "<td colspan=3>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "3" ]
  then
    echo "<td colspan=2>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "4" ]
  then
    echo "<td colspan=1>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  echo "</table>">> ${SitePath}/${VenuePath}/index.html
  echo "</div>">> ${SitePath}/${VenuePath}/index.html

  #########################################################################
  #########################################################################
  ##
  ##  get the junior NHRA numbers
  ##
  #########################################################################
  #########################################################################

  echo
  echo "Generating images by junior car number..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Juniors by NHRA Number:</h2>" >> ${FullBasePath}/index.html

  if [ ! -d ${FullGalleryPath}/ByJunior ]
  then
    mkdir ${FullGalleryPath}/ByJunior 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByJunior"
      echo ; echo
      exit
    fi
  fi

  ImageCount=0
  echo "<div align="center">">> ${SitePath}/${VenuePath}/index.html
  echo "<table cellspacing=15 cellpadding=3 border=0>">> ${SitePath}/${VenuePath}/index.html
  echo "<tr>">> ${SitePath}/${VenuePath}/index.html

  for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select num from vehicle where type = 'junior' order by num"`
  ## for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select num from vehicle where type = 'junior' order by num limit 11"`  ##  for testing
  do
    echo "  $VehicleNumber"

    VehicleGalleryPath=${FullGalleryPath}/ByJunior/$VehicleNumber

    if [ ! -d ${VehicleGalleryPath} ]
    then
      mkdir ${VehicleGalleryPath} 2>/dev/null
      if [ $? != 0 ]
      then
	echo ; echo
	echo "Failed to create ${VehicleGalleryPath}"
	echo ; echo
	exit
      fi
    fi

    ##  create the vehicle specific Info file

    echo "$VehicleNumber" > ${VehicleGalleryPath}/Info
    echo "${VehicleNumber}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${VehicleGalleryPath}/Info
    echo "NHRA, drag, race, racing, auto, automobile, car, photo, photography" >> ${VehicleGalleryPath}/Info
    echo "&nbsp;" >> ${VehicleGalleryPath}/Info

    cp Prototypes/CreateDRDriverIndex.ksh ${VehicleGalleryPath}/CreateIndex.ksh

    ##  only 1 section for a vehicle gallery

    echo "$VehicleNumber" > ${VehicleGalleryPath}/Section10
    for VehicleImage in `${ProgPrefix}/NewQuery racepics "select distinct id from image where vehnum = '${VehicleNumber}' order by id"`
    do
      ## echo "    $VehicleImage"
      ## echo "${VehicleImage}.jpg &nbsp;" >> ${VehicleGalleryPath}/Section10

      unset ImageFile
      for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${VehicleImage}* 2>/dev/null | awk '{ print $NF }'`
      do
        echo "`basename ${ImageFile}` &nbsp;" >> ${VehicleGalleryPath}/Section10
      done  ##  for each ImageFile
      if [ -z "$ImageFile" ]
      then
	echo "$loopImage" >> ${VehicleGalleryPath}/ImagesMissing
      fi  ##  if null ImageFile

    done  ##  for each vehicle image

    ##  create the vehicle index

    ( cd $VehicleGalleryPath ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 

    ##  add to main venue index.html

    if [ "$ImageCount" = "4" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByJunior/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      echo "</tr>" >> ${SitePath}/${VenuePath}/index.html
      echo "" >> ${SitePath}/${VenuePath}/index.html
      echo "<tr>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=5
    fi  #  if ImageCount is 4

    if [ "$ImageCount" = "3" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByJunior/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
     ImageCount=4
    fi

    if [ "$ImageCount" = "2" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByJunior/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=3
    fi

    if [ "$ImageCount" = "1" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByJunior/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=2
    fi

    if [ "$ImageCount" = "0" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByJunior/${VehicleNumber}/\">${VehicleNumber}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=1
    fi

    if [ "$ImageCount" = "5" ]
    then
      ImageCount=0
    fi

  done  ##  for each VehicleNumber

  ##  end the junior table

  if [ "$ImageCount" = "0" ]
  then
    echo "<td colspan=5>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "1" ]
  then
    echo "<td colspan=4>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "2" ]
  then
    echo "<td colspan=3>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "3" ]
  then
    echo "<td colspan=2>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "4" ]
  then
    echo "<td colspan=1>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  echo "</table>">> ${SitePath}/${VenuePath}/index.html
  echo "</div>">> ${SitePath}/${VenuePath}/index.html

  #########################################################################
  #########################################################################
  ##
  ##  vehicles by make
  ##
  #########################################################################
  #########################################################################

  echo
  echo "Generating images by Make..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Cars by Make:</h2>" >> ${FullBasePath}/index.html

  if [ ! -d ${FullGalleryPath}/ByMake ]
  then
    mkdir ${FullGalleryPath}/ByMake 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByMake"
      echo ; echo
      exit
    fi
  fi

  ImageCount=0
  echo "<div align="center">">> ${SitePath}/${VenuePath}/index.html
  echo "<table cellspacing=15 cellpadding=3 border=0>">> ${SitePath}/${VenuePath}/index.html
  echo "<tr>">> ${SitePath}/${VenuePath}/index.html

  for VehicleMake in `${ProgPrefix}/NewQuery racepics "select distinct make from vehicle order by make"`
  ## for VehicleMake in `${ProgPrefix}/NewQuery racepics "select distinct make from vehicle order by make limit 11"`  ##  for testing
  do
    echo "  $VehicleMake"

    VehicleGalleryPath=${FullGalleryPath}/ByMake/$VehicleMake

    if [ ! -d ${VehicleGalleryPath} ]
    then
      mkdir ${VehicleGalleryPath} 2>/dev/null
      if [ $? != 0 ]
      then
	echo ; echo
	echo "Failed to create ${VehicleGalleryPath}"
	echo ; echo
	exit
      fi
    fi

    ##  create the vehicle specific Info file

    echo "$VehicleMake" > ${VehicleGalleryPath}/Info
    echo "${VehicleMake}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${VehicleGalleryPath}/Info
    echo "${VehicleMake}, NHRA, drag, race, racing, auto, automobile, car, photo, photography" >> ${VehicleGalleryPath}/Info
    echo "&nbsp;" >> ${VehicleGalleryPath}/Info

    cp Prototypes/CreateDRDriverIndex.ksh ${VehicleGalleryPath}/CreateIndex.ksh

    ##  only 1 section for a vehicle gallery

    echo "$VehicleMake" > ${VehicleGalleryPath}/Section10
    for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select distinct num from vehicle where make = '${VehicleMake}' order by num"`
    ## for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select distinct num from vehicle where make = '${VehicleMake}' order by num limit 11"`  ##  for testing
    do
      for VehicleImage in `${ProgPrefix}/NewQuery racepics "select distinct id from image where vehnum = '${VehicleNumber}' order by id"`
      do
	## echo "    $VehicleImage"
	## echo "${VehicleImage}.jpg &nbsp;" >> ${VehicleGalleryPath}/Section10

	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${VehicleImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${VehicleGalleryPath}/Section10
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${VehicleGalleryPath}/ImagesMissing
	fi  ##  if null ImageFile

      done  ##  for each vehicle image
    done  ##  for each vehicle make

    ##  create the vehicle index

    ( cd $VehicleGalleryPath ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 

    ##  add to main venue index.html

    if [ "$ImageCount" = "4" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByMake/${VehicleMake}/\">${VehicleMake}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      echo "</tr>" >> ${SitePath}/${VenuePath}/index.html
      echo "" >> ${SitePath}/${VenuePath}/index.html
      echo "<tr>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=5
    fi  #  if ImageCount is 4

    if [ "$ImageCount" = "3" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByMake/${VehicleMake}/\">${VehicleMake}</a></td>" >> ${SitePath}/${VenuePath}/index.html
     ImageCount=4
    fi

    if [ "$ImageCount" = "2" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByMake/${VehicleMake}/\">${VehicleMake}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=3
    fi

    if [ "$ImageCount" = "1" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByMake/${VehicleMake}/\">${VehicleMake}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=2
    fi

    if [ "$ImageCount" = "0" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByMake/${VehicleMake}/\">${VehicleMake}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=1
    fi

    if [ "$ImageCount" = "5" ]
    then
      ImageCount=0
    fi

  done  ##  for each VehicleMake

  ##  end the make table

  if [ "$ImageCount" = "0" ]
  then
    echo "<td colspan=5>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "1" ]
  then
    echo "<td colspan=4>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "2" ]
  then
    echo "<td colspan=3>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "3" ]
  then
    echo "<td colspan=2>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "4" ]
  then
    echo "<td colspan=1>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  echo "</table>">> ${SitePath}/${VenuePath}/index.html
  echo "</div>">> ${SitePath}/${VenuePath}/index.html

  #########################################################################
  #########################################################################
  ##
  ##  vehicle by model
  ##
  #########################################################################
  #########################################################################

  echo
  echo "Generating images by Model..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Cars by Model:</h2>" >> ${FullBasePath}/index.html

  if [ ! -d ${FullGalleryPath}/ByModel ]
  then
    mkdir ${FullGalleryPath}/ByModel 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByModel"
      echo ; echo
      exit
    fi
  fi

  ImageCount=0
  echo "<div align="center">">> ${SitePath}/${VenuePath}/index.html
  echo "<table cellspacing=15 cellpadding=3 border=0>">> ${SitePath}/${VenuePath}/index.html
  echo "<tr>">> ${SitePath}/${VenuePath}/index.html

  ${ProgPrefix}/NewQuery racepics "select distinct model from vehicle order by model" > tmp_cdr_models
  ## ${ProgPrefix}/NewQuery racepics "select distinct model from vehicle order by model limit 11" > tmp_cdr_models  ##  for testing

  exec 4<tmp_cdr_models
  while read -u4 ModelRaw
  do
    VehicleModel=`${ProgPrefix}/URLEncode "${ModelRaw}"`
    echo "  $ModelRaw --> $VehicleModel"

    VehicleGalleryPath=${FullGalleryPath}/ByModel/$VehicleModel

    if [ ! -d ${VehicleGalleryPath} ]
    then
      mkdir ${VehicleGalleryPath} 2>/dev/null
      if [ $? != 0 ]
      then
	echo ; echo
	echo "Failed to create ${VehicleGalleryPath}"
	echo ; echo
	exit
      fi
    fi

    ##  create the vehicle specific Info file

    echo "$ModelRaw" > ${VehicleGalleryPath}/Info
    echo "${ModelRaw}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${VehicleGalleryPath}/Info
    echo "${ModelRaw}, NHRA, drag, race, racing, auto, automobile, car, photo, photography" >> ${VehicleGalleryPath}/Info
    echo "&nbsp;" >> ${VehicleGalleryPath}/Info

    cp Prototypes/CreateDRDriverIndex.ksh ${VehicleGalleryPath}/CreateIndex.ksh

    ##  only 1 section for a vehicle gallery

    echo "$ModelRaw" > ${VehicleGalleryPath}/Section10
    for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select distinct num from vehicle where model = '${ModelRaw}' order by num"`
    ## for VehicleNumber in `${ProgPrefix}/NewQuery racepics "select distinct num from vehicle where model = '${ModelRaw}' order by num limit 11"`  ##  for testing
    do
      for VehicleImage in `${ProgPrefix}/NewQuery racepics "select distinct id from image where vehnum = '${VehicleNumber}' order by id"`
      do
	## echo "    $VehicleImage"
	echo "${VehicleImage}.jpg &nbsp;" >> ${VehicleGalleryPath}/Section10

	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${VehicleImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${VehicleGalleryPath}/Section10
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${VehicleGalleryPath}/ImagesMissing
	fi  ##  if null ImageFile

      done  ##  for each vehicle image
    done  ##  for each vehicle number

    ##  create the vehicle index

    ( cd $VehicleGalleryPath ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 

    ##  add to main venue index.html

    if [ "$ImageCount" = "4" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByModel/${VehicleModel}/\">${ModelRaw}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      echo "</tr>" >> ${SitePath}/${VenuePath}/index.html
      echo "" >> ${SitePath}/${VenuePath}/index.html
      echo "<tr>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=5
    fi  #  if ImageCount is 4

    if [ "$ImageCount" = "3" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByModel/${VehicleModel}/\">${ModelRaw}</a></td>" >> ${SitePath}/${VenuePath}/index.html
     ImageCount=4
    fi

    if [ "$ImageCount" = "2" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByModel/${VehicleModel}/\">${ModelRaw}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=3
    fi

    if [ "$ImageCount" = "1" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByModel/${VehicleModel}/\">${ModelRaw}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=2
    fi

    if [ "$ImageCount" = "0" ]
    then
      echo "<td align=\"left\" valign=\"top\"><a href=\"${FullSiteURL}/Galleries/ByModel/${VehicleModel}/\">${ModelRaw}</a></td>" >> ${SitePath}/${VenuePath}/index.html
      ImageCount=1
    fi

    if [ "$ImageCount" = "5" ]
    then
      ImageCount=0
    fi

  done  ##  for each ModelRaw
  exec 4<&-

  ##  end the model table

  if [ "$ImageCount" = "0" ]
  then
    echo "<td colspan=5>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "1" ]
  then
    echo "<td colspan=4>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "2" ]
  then
    echo "<td colspan=3>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "3" ]
  then
    echo "<td colspan=2>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  if [ "$ImageCount" = "4" ]
  then
    echo "<td colspan=1>&nbsp;</td>"  >> ${SitePath}/${VenuePath}/index.html
    echo "</tr>"  >> ${SitePath}/${VenuePath}/index.html
    echo "<tr><td colspan=5>&nbsp;</td></tr>"  >> ${SitePath}/${VenuePath}/index.html
  fi

  echo "</table>">> ${SitePath}/${VenuePath}/index.html
  echo "</div>">> ${SitePath}/${VenuePath}/index.html

  #########################################################################
  #########################################################################
  ##
  ##  unidentified vehicles
  ##
  #########################################################################
  #########################################################################

  echo
  echo "Generating images by unidentified..."

  echo "<br clear=all>" >> ${FullBasePath}/index.html
  echo "<h2>Unidentified Vehicles:</h2>" >> ${FullBasePath}/index.html

  if [ ! -d ${FullGalleryPath}/ByUnknown ]
  then
    mkdir ${FullGalleryPath}/ByUnknown 2>/dev/null
    if [ $? != 0 ]
    then
      echo ; echo
      echo "Failed to create ${FullGalleryPath}/ByUnknown"
      echo ; echo
      exit
    fi
  fi

  echo "<ul>" >> ${FullBasePath}/index.html
  for VehicleType in `${ProgPrefix}/NewQuery racepics "select distinct type from vehicle order by type"`
  do
    for VehicleNum in `${ProgPrefix}/NewQuery racepics "select distinct num from vehicle where type = '${VehicleType}' and num like 'Unkn%'"`
    ## for VehicleNum in `${ProgPrefix}/NewQuery racepics "select distinct num from vehicle where type = '${VehicleType}' and num like 'Unkn%' limit 2"`  ##  for testing
    do
      echo "  $VehicleType - $VehicleNum"
      unset ThisDir
      VehicleName=`${ProgPrefix}/NewQuery racepics "select name from vehicle where num = '${VehicleNum}'"`

      ##
      ##  add vehicle to main index
      ##

      echo "<li><a href=""${FullSiteURL}/Galleries/ByUnknown/${VehicleNum}/"">${VehicleType} - ${VehicleNum} - ${VehicleName}</a>" >> ${FullBasePath}/index.html

      ##
      ##  create the vehicle directory, section file, and the index
      ##

      if [ ! -d ${FullGalleryPath}/ByUnknown/${VehicleNum} ]
      then
	mkdir ${FullGalleryPath}/ByUnknown/${VehicleNum} 2>/dev/null
	if [ $? != 0 ]
	then
	  echo ; echo
	  echo "Failed to create ${FullGalleryPath}/ByUnknown/${VehicleNum}"
	  echo ; echo
	  exit
	fi
      fi

      ThisDir=${FullGalleryPath}/ByUnknown/${VehicleNum}

      echo "$VehicleNum" > ${ThisDir}/Info
      echo "${VehicleNum} - ${VehicleName}.  Photos by and copyright Douglas A. Greenwald, all rights reserved." >> ${ThisDir}/Info
      echo "${VehicleName}, NHRA, drag, race, racing, auto, automobile, car, photo, photography" >> ${ThisDir}/Info
      echo "&nbsp;" >> ${ThisDir}/Info

      ##  create the section file

      echo "$VehicleNum" > ${ThisDir}/Section10
      ## ${ProgPrefix}/NewQuery racepics "select id from image where vehnum = '${VehicleNum}' order by id" >> ${ThisDir}/Section10

      for VehicleImage in `${ProgPrefix}/NewQuery racepics "select id from image where vehnum = '${VehicleNum}' order by id"`
      do
        ## echo "    $VehicleImage"
        ## echo "${VehicleImage}.jpg &nbsp;" >> ${VehicleGalleryPath}/Section10

	unset ImageFile
	for ImageFile in `ls -l ${SitePath}/${VenuePath}/AllImages/${VehicleImage}* 2>/dev/null | awk '{ print $NF }'`
	do
          echo "`basename ${ImageFile}` &nbsp;" >> ${ThisDir}/Section10
	done  ##  for each ImageFile
	if [ -z "$ImageFile" ]
	then
	  echo "$loopImage" >> ${ThisDir}/ImagesMissing
	fi  ##  if null ImageFile

      done  ##  for each vehicle image

      cp Prototypes/CreateDRDriverIndex.ksh ${ThisDir}/CreateIndex.ksh

      ( cd $ThisDir ; ./CreateIndex.ksh $VenuePath > /dev/null 2>&1 ) 


    done  ##  for each vehicle num
  done  ##  for each vehicle type
  echo "</ul>" >> ${FullBasePath}/index.html


done  ##  for each venue



##
##  end the venue index
##

cat >> ${SitePath}/${VenuePath}/index.html <<EOF


</body>
</html>
EOF
