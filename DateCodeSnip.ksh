#  assumed that DATE would be sed replaced by the date from the database
#  format is YYYY-MM-DD

GalleryDate="DATE"

#  convert the gallery date - YYYY-MM-DD - into display strings

GalleryYear=`echo ${GalleryDate} | awk -F "-" '{ print $1 }'`
Month=`echo ${GalleryDate} | awk -F "-" '{ print $2 }'`
GalleryDay=`echo ${GalleryDate} | awk -F "-" '{ print $3 }'`

if [ "${Month}" = "01" ]
then
  GalleryMonth="January"
fi
if [ "${Month}" = "02" ]
then
  GalleryMonth="February"
fi
if [ "${Month}" = "03" ]
then
  GalleryMonth="March"
fi
if [ "${Month}" = "04" ]
then
  GalleryMonth="April"
fi
if [ "${Month}" = "05" ]
then
  GalleryMonth="May"
fi
if [ "${Month}" = "06" ]
then
  GalleryMonth="June"
fi
if [ "${Month}" = "07" ]
then
  GalleryMonth="July"
fi
if [ "${Month}" = "08" ]
then
  GalleryMonth="August"
fi
if [ "${Month}" = "09" ]
then
  GalleryMonth="September"
fi
if [ "${Month}" = "10" ]
then
  GalleryMonth="October"
fi
if [ "${Month}" = "11" ]
then
  GalleryMonth="November"
fi
if [ "${Month}" = "12" ]
then
  GalleryMonth="December"
fi

#  gives us GalleryMonth GalleryDay, GalleryYear
