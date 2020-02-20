#!/bin/bash
#
# Query NUT UPS status and output in InfluxDB Line Protocol
#
# Usage: ups.sh upsname[@hostname[:port]]
# (same as `upsc`, see https://networkupstools.org/docs/man/upsc.html)
#
set -euo pipefail
IFS=$'\n\t'

function join { local IFS="$1"; shift; echo "$*"; }

declare -A vars=();

# read UPS status into `vars`
while IFS=": " read -r k v; do
  vars[$k]="$v"
done < <(upsc $* 2>/dev/null)

# exit if empty/unsuccessful
[[ -z "${vars-}" ]] || exit 1

# print a metric in InfluxDB line format
tags=(
  ups=${1%%@*}
)
fields=(
  status=${vars["ups.status"]}
  load=${vars["ups.load"]}
  battery_charge=${vars["battery.charge"]}
  battery_runtime=${vars["battery.runtime"]}
  battery_runtime_low=${vars["battery.runtime.low"]}
  battery_voltage=${vars["battery.voltage"]}
  battery_voltage_nominal=${vars["battery.voltage.nominal"]}
  input_voltage=${vars["input.voltage"]}
  input_voltage_nominal=${vars["input.voltage.nominal"]}
  timer_reboot=${vars["ups.timer.reboot"]:--1}
  timer_shutdown=${vars["ups.timer.shutdown"]:--1}
)
time=$(date +%s%N)

echo "ups,$(join , ${tags[@]}) $(join , ${fields[@]}) $time"
