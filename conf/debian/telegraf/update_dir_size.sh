#!/bin/bash

time=$(date +%s%N)
du -ks "$@" | awk '{if (NR!=1) {printf ",\n"};printf "dir_size directory_size_kilobytes="$1",path=\""$2"\" "$time;}'
echo