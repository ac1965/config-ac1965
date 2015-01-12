yaourt -Ss cnijifilter
cd
vi customize_airootfs.sh 
./customize_airootfs.sh 
ls
vi customize_airootfs.sh 
./customize_airootfs.sh 
grub-install /dev/sdb --boot-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
cd
ls
cd airootfs/
ls
cd root/
ls
cd
ls
ls tmp/
cd tmp/
ls
vi grub-dev.sh 
ls
vi grub.bak 
ls
cp grub.bak grub
./grub-dev.sh 
vi /etc/default/grub 
vi /boot/grub/grub.cfg
blkid /dev/sdb2
blkid /dev/mapper/756657f31c8a4a6bb52cc5b15180056e-root 
ls /mnt/
ls /boot/
ls /boot/backup/
ls /boot/backup/tjy/
ls /boot/
find /boot/ -name grub
ls /boot/backup/tjy/archlinux/grub 
diff -u /etc/default/grub /boot/backup/tjy/archlinux/grub 
more /boot/backup/tjy/archlinux/grub 
cd /boot/grub/
ls
vi grub.cfg
grub-mkconfig 
grub-mkconfig > /boot/grub/grub.cfg
more /boot/grub/grub.cfg
more /boot/grub/grub.cfg
vi /etc/mkinitcpio.conf 
mkinitcpio -p linux
ls
cd
cd tmp/
ls
cp /etc/mkinitcpio.conf .
passwd
passwd
ls
cd
ls
vi customize_airootfs.sh 
ls
cd tmp/
ls
vi mkinitcpio.conf 
ls
vi grub.bak 
mv grub.bak grub
ls
cd ..
cd tmp/
vi grub-dev.sh 
cd /root/
ls
cd tmp/
ls
cd ..
cd airootfs/
ls
find .
ls usr/share/fonts/
cd usr/share/fonts/
ls /usr/share/fonts/TTF/
ls
find 
find . -type f
find . -type f|awk '{printf "rm /usr/share/fonts/%s\n", $1}'
ls /usr/share/fonts/
find . -type f|awk '{printf "rm /usr/share/fonts/%s\n", $1}'|sh -x
fc-cache 
