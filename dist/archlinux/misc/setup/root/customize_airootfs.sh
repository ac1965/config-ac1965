#!/bin/bash

set -e -u

user=tjy

echo mybox > /etc/hostname

sed -i 's/#\(ja_JP\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

usermod -s /usr/bin/zsh root

if [ ! -d /root ]
then
	mkdir /root && chown root /root
fi

cp -aT /etc/skel/ /root/
cp -a -l -f /root/airootfs/. /

chown -R root:root /etc/skel
chown -R root:root /usr/share/fonts
chown -R root:root /usr/share/licenses
chown -R root:root /etc/sudoers.d
chown -R root:root /etc/pacman.d
chown -R root:root /etc/grub.d

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

test -f /root/tmp/vconsole.conf &&  cp /root/tmp/vconsole.conf /etc
test -f /root/tmp/mkinitcpio.conf && cp /root/tmp/mkinitcpio.conf /etc &&  mkinitcpio -p linux
test -f /root/tmp/grub && sh /root/tmp/grub-dev.sh && grub-mkconfig -o /boot/grub/grub.cfg
test -f /etc/vconsole.conf && chown root:root /etc/vconsole.conf
test -f /etc/mkinitcpio.conf && chown root:root /etc/mkinitcpio.conf


test -d /home/${user} || useradd -m -p "" -g users -G "adbusers,adm,audio,cdemu,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash ${user}
test -d /home/${user}/archives || su -c 'mkdir ~/archives' ${user}
test -d /home/${user}/archives/config-ac1965/.git && su -c 'cd ~/archives/config-ac1965 ; git pull' ${user}
test -d /home/${user}/archives/config-ac1965/.git || su -c 'cd ~/archives ; git clone https://github.com/ac1965/config-ac1965.git' ${user}
su -c 'cd ~/archives/config-ac1965; sh setup.sh' ${user}

systemctl enable NetworkManager.service
systemctl enable slim.service

grep '\.jp/' /etc/pacman.d/mirrorlist | sed "s/#Server/Server/g" > _mirrorlist
mv _mirrorlist /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

su -c 'yaourt -Syy --noconfirm' ${user}

# disable pc speaker beep
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# other packages
cp /root/tmp/packages /tmp
su -c 'yaourt -S $(grep -v '^!' /tmp/packages) --needed --noconfirm --noprogressbar' ${user}
fc-cache

rm -fr /tmp/*


# disable network stuff
rm /etc/udev/rules.d/81-dhcpcd.rules
rm /var/cache/pacman/pkg/*
rm -fr /tmp/*

#---
