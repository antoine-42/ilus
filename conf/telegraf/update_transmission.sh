#!/bin/bash
#
# Query transmission stats.json file and output in InfluxDB Line Protocol
#
# Usage: update_transmission path/to/stats.json
#
# Adapted from update_ups.sh
#
set -euo pipefail
IFS=$'\n\t'

function join { local IFS="$1"; shift; echo "$*"; }

declare -A vars=();

# Read stats.json file
{
    # Skip first line
    read
    while IFS=": " read -r k v; do
      vars[${k//\"}]="$v"
    done
} < $1

# exit if empty/unsuccessful
[[ -z "${vars-}" ]] || exit 1

# print a metric in InfluxDB line format
fields=(
  downloaded_bytes=${vars["downloaded-bytes"]}
  files_added=${vars["files-added"]}
  seconds_active=${vars["seconds-active"]}
  session_count=${vars["session-count"]}
  uploaded_bytes=${vars["uploaded-bytes"]}
)
time=$(date +%s%N)

echo "transmission, $(join , ${fields[@]}) $time"
