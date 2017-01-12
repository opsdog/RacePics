#!/bin/ksh
##
##  script to create the Affirmations page
##

##
##  initialize stuff
##

if [ -d /Volumes/External300/DBProgs/RacePics ]
then
  ProgPrefix="/Volumes/External300/DBProgs/RacePics"
else
  ProgPrefix="/Users/douggreenwald/RacePics"
fi

unset MYSQL
. /Volumes/External300/DBProgs/FSRServers/DougPerfData/SetDBCase.ksh


if [ -f /Volumes/Space5/Present ]
then
  AffirmDir="/Volumes/Space5/ImageKind/Affirmations"
else
  AffirmDir="/Volumes/External300/Volumes/Space5/ImageKind/Affirmations"
fi

WorkDir="`pwd`/Affirmations"
AffirmHTML="${WorkDir}/Affirmations.html"
InsertFile="${WorkDir}/AffirmInserts.sql"
UpdateFile="${WorkDir}/AffirmUpdates.sql"

if [ ! -d ${WorkDir} ]
then
  mkdir -p ${WorkDir}
  mkdir -p ${WorkDir}/Images
  mkdir -p ${WorkDir}/FontSamples
  chmod 0755 ${WorkDir}
  chmod 0755 ${WorkDir}/Images
  chmod 0755 ${WorkDir}/FontSamples
fi

TODAY=`date +"%B %d, %Y"`

echo "Making required executables..."

( cd $ProgPrefix ; make ) >/dev/null 2>&1

##
##  build the affirmations page
##

echo
echo "Building affirmations page..."

cd $AffirmDir

cat > $AffirmHTML <<EOF
<html>
<head>
<title>Affirmations Prints and Posters</title>
<!--  <link rel=stylesheet href="http://www.daemony.com/Styles/SelfPorts01.css" type="text/css">  -->
<link rel=stylesheet href="AffPrints.css" type="text/css">

<meta name="description" content="Images and words of love, hope, and faith.  Photography and words by and Copyright Douglas A. Greenwald, all rights reserved." />
<meta name="revision" content="$TODAY" />
</head>
<body>
<h1 align=center>Affirmations Prints and Posters</h1>
<ul>
EOF

##
##  add the sections to the affirmations page
##

for Section in `${ProgPrefix}/NewQuery racepics "select distinct type from saying order by type"`
do
  case ${Section} in
    "love"   )  SectionName="Love" ;;
    "rel"    )  SectionName="Faith" ;;
    "xmas"   )  SectionName="Christmas" ;;
    "ween"   )  SectionName="Halloween" ;;
    "invite" )  SectionName="Invitation" ;;
    "xxx"    )  SectionName="Erotic" ;;
  esac
  echo "<li><a href=\"#${Section}\">${SectionName}</a>" >> $AffirmHTML
done

echo "</ul>" >> $AffirmHTML

##
##  each affirmation should show a sample image (the first?) and then
##  list the available fonts.  each listed font should take you to
##  the zenfolio page to purchase
##

##
##  overall page by type (Section)
##    then by saying
##      then by image - select distinct image from aimage where prefix = 'P';
##        then by font - select fontnum from aimage where prefix = 'P' and image = 'DSCN3697-Fract04';
##

for Section in `${ProgPrefix}/NewQuery racepics "select distinct type from saying order by type"`
do

  case ${Section} in
    "love"   )  SectionName="Love" ;;
    "rel"    )  SectionName="Faith" ;;
    "xmas"   )  SectionName="Christmas" ;;
    "ween"   )  SectionName="Halloween" ;;
    "invite" )  SectionName="Invitation" ;;
    "xxx"    )  SectionName="Erotic" ;;
  esac
  echo "<a name=\"${Section}\"></a>" >> $AffirmHTML
  echo "<h2 align=\"center\">${SectionName}</h2>" >> $AffirmHTML

  ${ProgPrefix}/CSVQuery racepics "select saying, prefix, id from saying where type = '${Section}' order by saying" > /tmp/affirmorder-$$

  ##
  ##  /tmp/affirmorder-$$ now has the list of sayings
  ##  display by distinct image per saying
  ##

  echo "<table cellpadding=3 cellspacing=5 border=0>" >> $AffirmHTML

  exec 4</tmp/affirmorder-$$
  while read -u4 SayingString
  do
    Saying=`echo $SayingString | awk -F \, '{ print $1 }'`
    Prefix=`echo $SayingString | awk -F \, '{ print $2 }'`
    SayingID=`echo $SayingString | awk -F \, '{ print $3 }'`

    echo "  $Prefix -- $SayingID"


    for Image in `${ProgPrefix}/NewQuery racepics "select distinct image from aimage where prefix = '${Prefix}'"`
    do

      ##  the the "first" image of this saying/image

      SampleImageString=`${ProgPrefix}/CSVQuery racepics "select image, fontnum from aimage where prefix = '${Prefix}' and image = '${Image}' order by fontnum" | head -1`

      echo "    Using sample $SampleImageString"
      
      ##  add HTML code to display the sample

      echo "<tr><td colspan=2>&nbsp;</td></tr>" >> $AffirmHTML
      echo "<tr>" >> $AffirmHTML
      echo "<td valign=\"top\" align=\"left\" width=\"60%\"><p>${Saying}</p>" >> $AffirmHTML

      ##  get all fonts for this image/prefix combination

      echo "<blockquote class=\"smaller\">Select your font...<br>" >> $AffirmHTML
      for FontNum in `${ProgPrefix}/NewQuery racepics "select fontnum from aimage where prefix = '${Prefix}' and image = '${Image}' order by fontnum"`
      do
        #echo "      FontNum $FontNum"

	##  generate HTML code for each font available for this image/prefix
	##  TODO - also get the zenfolio link to this specific saying/image/font

	FontName=`${ProgPrefix}/NewQuery racepics "select name from fonts where id = $FontNum"`
	FontNum2D=`printf "%02d" $FontNum`

	ZFInfo=`${ProgPrefix}/CSVQuery racepics "select zfgal, zfid from commerce where id='${Prefix}_${Image}_${FontNum2D}'"`
	ZFGal=`echo $ZFInfo | awk -F, '{ print $1 }'`
	ZFID=`echo $ZFInfo | awk -F, '{ print $2 }'`
	ZFURL="http://opsdog.zenfolio.com/p${ZFGal}/?photo=${ZFID}"

	# echo "    --> SampleImageString:  $SampleImageString"
	# echo "    --> FontName:           $FontName"
	# echo "    --> FontNum:            $FontNum"
	# echo "    --> FontNum2D:          $FontNum2D"
	# echo "    --> Image:              $Image"
	# echo "    --> Section:            $Section"
        # echo "    --> Prefix:             $Prefix"
	# echo "    --> ZFInfo:             $ZFInfo"
	# echo "    --> ZFGal:              $ZFGal"
	# echo "    --> ZFID:               $ZFID"
	# echo "    --> ZFURL:              $ZFURL"

#	echo "<a href=\"${ZFURL}\"><img src=\"${WorkDir}/FontSamples/FontSample-${FontNum}.jpg\" alt=\"${FontName}\" /></a>" >> $AffirmHTML
	echo "<a href=\"${ZFURL}\"><img src=\"FontSamples/FontSample-${FontNum}.jpg\" alt=\"${FontName}\" /></a>" >> $AffirmHTML

      done  ##  for each font
      echo "</blockquote>" >> $AffirmHTML
      echo "</td>" >> $AffirmHTML
      FN=`echo $SampleImageString | awk -F \, '{ print $2 }'`
      FontNum=`printf "%02d" $FN`
      #echo "    --> $FontNum"
#      echo "<td class=\"SampleImage\" width=\"350\"><img src=\"${WorkDir}/Images/${Prefix}_${Image}_${FontNum}.jpg\" /></td>" >> $AffirmHTML
      echo "<td class=\"SampleImage\" width=\"350\"><img src=\"Images/${Prefix}_${Image}_${FontNum}.jpg\" /></td>" >> $AffirmHTML
      echo "</tr>" >> $AffirmHTML
      echo "<tr><td colspan=2>&nbsp;</td></tr>" >> $AffirmHTML
      echo "<tr><td colspan=2><hr /></td></tr>" >> $AffirmHTML
    done  ##  for each image used by the Prefix

  done  ##  while reading /tmp/affirmorder
  exec 4<&-

  echo "</table>" >> $AffirmHTML

done  ##  for each Section

rm -f /tmp/affirmorder-$$

##
##  finish the affirmations page
##
cat >> $AffirmHTML <<EOF

<div align="center">
<p class="caption">All content Copyright 1994-2012 Douglas A. Greenwald</p>
</div>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-5472467-1");
pageTracker._trackPageview();
</script>

</body>
</html>
EOF

chmod 0644 $AffirmHTML

