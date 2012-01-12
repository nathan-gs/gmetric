#!/bin/bash
# author: Nathan Bijnens <nathan@nathan.gs>
# desc:   smart temperature to ganglia.

# detect harddrives.

HARDDISKS=`find /sys/block/ -name 'sd*' -printf "%f\n"`

GMETRIC=/usr/bin/gmetric

for disk in $HARDDISKS; do
	Temp=`smartctl -A /dev/$disk | grep Temperature_Celsius | awk '{print $10}'`
#	Airflow_Temp=`smartctl -A /dev/$disk | grep Airflow_Temperature_Cel | awk '{print $10}'`

	$GMETRIC -t float -n "disk_$disk_temp" -u "C" -v $Temp
#	$GMETRIC -t float -n "disk_$disk_air_temp" -u "C" -v $Airflow_Temp
done

Max_Temp=`for disk in \`find /sys/block/ -name 'sd*' -printf "%f\n"\`; do smartctl -A /dev/$disk | grep Temperature_Celsius | awk '{print $10}'; done | sort -r | head -1`
#Max_Airflow_Temp=`for disk in `find /sys/block/ -name 'sd*' -printf "%f\n"`; do smartctl -A /dev/$disk | grep Airflow_Temperature_Cel | awk '{print $10}'; done | sort -r | head -1`
$GMETRIC -t float -n "disk_temp" -u "C" -v $Max_Temp
#$GMETRIC -t float -n "disk_air_temp" -u "C" -v $Max_Airflow_Temp

