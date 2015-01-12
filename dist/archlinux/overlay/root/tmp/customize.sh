#! /bin/sh

set -e -u

host='mybox'
user='tjy'

echo ${host} > /etc/hostname

test -f /root/tmp/vconsole.conf &&  cp /root/tmp/vconsole.conf /etc

sed -i 's/#\(ja_JP\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo 'LANG=ja_JP.UTF8' > /etc/locale.conf

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock -w --utc

cp -aT /etc/skel /root

test -f /root/tmp/mkinitcpio.conf && cp /root/tmp/mkinitcpio.conf /etc &&  mkinitcpio -p linux
if [ -f /root/tmp/grub ]; then
    sh /root/tmp/grub-dev.sh && grub-mkconfig -o /boot/grub/grub.cfg
else
    grub-mkconfig -o /boot/grub/grub.cfg
fi

pacman -Q slim-themes >/dev/null 2>&1 && test -f /root/tmp/slim.conf && cp /root/tmp/slim.conf /etc
pacman -Q android-tools >/dev/null 2>&1 &&  \
    useradd -p "" -m  -g users -G "adbusers,adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash ${user} || \
    useradd -p "" -m  -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash ${user}
su -c 'mkdir /home/tjy/tmp && cd /home/tjy/tmp && git clone https://github.com/ac1965/config-ac1965.git' ${user}
