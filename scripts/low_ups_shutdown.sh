#!/usr/bin/env bash

LOG_LOCATION="/var/log/low_battery.log"
UPSC_RESULT="$(upsc eaton-ellipse-650@127.0.0.1)"
CRITICAL_PERCENTAGE="$(echo ${UPSC_RESULT} | grep battery.charge.low: | cut -c 21-22)"
CURRENT_PERCENTAGE="$(echo ${UPSC_RESULT} | grep battery.charge: | cut -c 17-19)"
CRITICAL_SECONDS_LEFT="$(expr 60 \* 5)"
CURRENT_SECONDS_LEFT="$(echo ${UPSC_RESULT} | grep battery.runtime: | cut -c 18-22)"

# Shutdown when less than 5 minutes left on battery and battery is being used.
if [[ CURRENT_SECONDS_LEFT -lt CRITICAL_SECONDS_LEFT && CURRENT_PERCENTAGE -lt 80 ]]
then
    echo "critical"
    echo "$(date --iso-8601=seconds)" >> $LOG_LOCATION
    echo "Battery at ${CURRENT_PERCENTAGE} %, only ${CURRENT_SECONDS_LEFT} seconds remaining. Shutting down." >> $LOG_LOCATION
    sudo shutdown
fi
