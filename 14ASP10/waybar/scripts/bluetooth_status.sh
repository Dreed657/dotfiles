#!/bin/bash

# Get all connected devices
connected_devices=$(bluetoothctl info | grep "Device" | awk '{print $2}')

if [ -z "$connected_devices" ]; then
    echo " Off"
    exit 0
fi

output=""
while read -r mac; do
    name=$(bluetoothctl info "$mac" | grep "Name:" | cut -d' ' -f2-)
    battery_line=$(bluetoothctl info "$mac" | grep "Battery Percentage")

    # Extract only the number in parentheses
    if [[ $battery_line =~ \(([0-9]+)\) ]]; then
        battery="${BASH_REMATCH[1]}%"
    else
        battery=""
    fi

    if [ -n "$battery" ]; then
        output+="  ${name} (${battery})  "
    else
        output+="  ${name}  "
    fi
done <<< "$connected_devices"

echo "$output"
