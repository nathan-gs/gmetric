#!/bin/bash
# author: Mike Snitzer <msnitzer@plogic.com>
# desc:   used to make lm_sensors metrics available to ganglia

GMETRIC_BIN=/usr/bin/gmetric
# establish a base commandline
GMETRIC="$GMETRIC_BIN"

SENSORS=/usr/bin/sensors

# send cpu temperatures
let count=0
    for temp in ` sensors | grep Core | sed "s/[^0-9]//g" | cut -b 2-3`; do 
    $GMETRIC -t float -n "cpu${count}_temp" -u "C" -v $temp 
    let count+=1
done
MAX_TEMP=`sensors | grep Core | sed "s/[^0-9]//g" | cut -b 2-3 | sort -n -r | head -1`
$GMETRIC -t float -n "cpu_temp" -u "C" -v $MAX_TEMP
