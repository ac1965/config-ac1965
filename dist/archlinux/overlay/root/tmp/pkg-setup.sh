# pacman-key --init
# pacman-key --popluate archlinux
# pacman-key -r CC1D2606 && pacman-key --lsign-key CC1D2606
# pacman-key --popluate archassault
# pacman -Suuy archassault-keyring archassault-mirrorlist

yaourt -Q cryptsetup && yaourt -R --noconfirm cryptsetup && yaourt -S --noconfirm --noprogressbar cryptsetup-nuke-keys
yaourt -S --needed --noconfirm --noprogressbar $(cat <<EOF | egrep -v '^(#|$)' 
xorg
xterm
i3-wm
i3lock
i3status-mpd-git

dosfstools
encfs
ntfsprogs

openntpd
networkmanager
network-manager-applet
networkmanager-dispatcher-openntpd

gdb

slim
slim-themes

anthy
autocutsel
chromium
chromium-pepper-flash
dmenu
feh
gnome-keyring
rxvt-unicode
scrot
udiskie
uim
urxvt-perls
xscreensaver
xclip
xpad

emacs
ispell
mpd
python2-mpd
vim
weechat
tcl
aspell

w3m
nkf
ncmpcpp-git
adobe-source-code-pro-fonts
adobe-source-sans-pro-fonts
ttf-sazanami
ttf-ms-fonts
ttf-inconsolata
otf-takao
ttf-ricty

cdparanoia

ffmpeg
lame
id3
libdvdcss
libmusicbrainz3
normalize

abcde
mplayer
vlc
cmus
dropbox
dropbox-cli
nautilus
youtube-dl

android-udev
android-tools

libnatspec
zip-natspec
unzip-natspec
p7zip-natspec
rar
unrar

qemu
virtualbox
virtualbox-host-modules
cnijfilter-mg6100
EOF
)
