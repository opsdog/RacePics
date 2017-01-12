#!/bin/ksh
#!/usr/local/bin/ksh
#
#

make Human > /dev/null 2>&1
make VehicleNum > /dev/null 2>&1

./Human > Human.$$
exec 4<Human.$$
while read -u4 Name
do
  echo k${Name}k
done
exec 4<&-

./VehicleNum > VehicleNum.$$
exec 4<VehicleNum.$$
while read -u4 Num
do
  echo k${Num}k
done
exec 4<&-
