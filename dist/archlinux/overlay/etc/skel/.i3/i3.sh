#! /bin/sh

WL=$(ip link | grep wl | cut -d' ' -f2 | sed 's/://')
AN=$(ls /sys/class/power_supply/|grep BAT|cut -b4)

cp ~/.i3/i3status-top.conf.tmpl ~/.i3/i3status-top.conf

sed -i 's/%WIRELESS%/'$WL'/' ~/.i3/i3status-top.conf
sed -i 's/%AC%/'$AN'/' ~/.i3/i3status-top.conf
