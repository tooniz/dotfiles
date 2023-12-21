#!/bin/bash

TIMEOUT="${1:-3000}"

selections=($(ird list | grep $USER | awk '{print $1}'))
for sel in "${selections[@]}"
do
    echo "> ird change-timeout $sel $TIMEOUT"
    ird change-timeout $sel $TIMEOUT
done
