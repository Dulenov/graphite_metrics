#!/bin/sh

# set up our graphite namespace
graphite_host="localhost"
graphite_port=2003
namespace="system.$(hostname).loadavg"

# get current time and loadavg
time=$(date +'%s')
load=$(cat /proc/loadavg)

# map describing loadavg format
# "metric_name:field_number"
one="1:1minute" 
five="2:5minute"
fifteen="3:15minute"

for avg in $one $five $fifteen; do
    index=$(echo $avg | cut -d ':' -f 1)
    value=$(echo $load | cut -d ' ' -f $index)
    metric=$(echo $avg | cut -d ':' -f 2)
    echo "${namespace}.${metric} ${value} ${time}" |
    nc $graphite_host $graphite_port
done;