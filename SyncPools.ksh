#!/bin/ksh
#!/usr/local/bin/ksh
#
#  synch the _Pool folders between the this and the desktop
#

if [ ! -f /Volumes/External300/Present ]
then

  echo "External300 isn't mounted, dipshit"
  exit

fi

if [ ! -f /Volumes/Space1/Present ]
then

  echo "Space1 isn't mounted, dipshit"
  exit

fi

LaptopPool=/Volumes/External300/Test/_Pool
#DesktopPool=/Volumes/Space1/Sites/Daemony.com/Personal/PhotoCollections/Transportation/Automobiles/Racing/_Pool
DesktopPool=/Volumes/Space1/Sites/Daemony.com/SpeedWorld/Galleries/_Pool

rm -f /tmp/SyncPools >/dev/null 2>&1

echo "---------------------------------------------------"
echo "  Syncing ${LaptopPool}"
echo "---------------------------------------------------"

cd ${LaptopPool}

find . -print | cpio -p -dv $DesktopPool 2>/tmp/SyncPools
echo $?

echo "---------------------------------------------------"
echo "  Syncing ${DesktopPool}"
echo "---------------------------------------------------"

cd ${DesktopPool}

find . -print | cpio -p -dv ${LaptopPool} 2>>/tmp/SyncPools
echo $?

