#!/bin/sh
if bluetoothctl info | grep -q "Connected: yes"; then
    echo "Connected"
else
    echo "Off"
fi
