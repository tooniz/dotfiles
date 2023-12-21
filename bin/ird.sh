#!/bin/bash

TIMEOUT="${1:-3000}"

names=($(ird list | grep $USER | awk '{print $5}'))
selections=($(ird list | grep $USER | awk '{print $1}'))

echo "Extending ($names) timeout to $TIMEOUT ..."

for sel in "${selections[@]}"
do
    echo "> ird change-timeout $sel $TIMEOUT"
    ird change-timeout $sel $TIMEOUT
done
