#!/bin/bash
#
# Query NUT UPS status and output in InfluxDB Line Protocol
#
# Usage: ups.sh upsname[@hostname[:port]]
# (same as `upsc`, see https://networkupstools.org/docs/man/upsc.html)
#
# Adapted from https://yegor.pomortsev.com/post/monitoring-everything/
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
  load=${vars["ups.load"]}
  battery_charge=${vars["battery.charge"]}
  battery_charge_low=${vars["battery.charge.low"]}
  battery_runtime=${vars["battery.runtime"]}
  timer_start=${vars["ups.timer.start"]:--1}
  timer_shutdown=${vars["ups.timer.shutdown"]:--1}
  input_transfer_high=${vars["input.transfer.high"]}
  input_transfer_low=${vars["input.transfer.low"]}
  outlet_power=${vars["outlet.power"]}
  output_voltage=${vars["output.voltage"]}
  output_voltage_nominal=${vars["output.voltage.nominal"]}
)
time=$(date +%s%N)

echo "ups,$(join , ${tags[@]}) $(join , ${fields[@]}) $time"
