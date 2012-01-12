#!/bin/bash
# author: Mike Snitzer <msnitzer@plogic.com>
# desc:   used to make lm_sensors metrics available to ganglia

GMETRIC_BIN=/usr/bin/gmetric
# establish a base commandline
GMETRIC="$GMETRIC_BIN -i $MCAST_IF"

SENSORS=/usr/bin/sensors

# send cpu temperatures
let count=0
    for temp in `${SENSORS} | grep emp | cut -b 13-16`; do 
    $GMETRIC -t float -n "cpu${count}_temp" -u "C" -v $temp 
    let count+=1
done

# send cpu fan speed
let count=0
    for fan in `${SENSORS} | grep fan | cut -b 9-14`; do
    $GMETRIC -t uint32 -n "cpu${count}_fan" -u "RPM" -v $fan
    let count+=1
done
