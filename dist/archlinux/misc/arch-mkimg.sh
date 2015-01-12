#! /bin/sh

# arch :: i686 or x86_64
# /root/image
#         cdrom :: .cdrom = iso image
#         sqfs  :: .sqfs  = ${cdrom}/arch/${arch}/root-image.fs.sfs
#         root  :: .root  = ${sqfs}/root-image.fs
#
#         edit     :: new_root
#         pacman.d :: ${root}/etc/pacman.d
#         pkgs     :: ${root}/var/cache/pacman/pkg

trap \
    'is_root_image ; umount_setup ${root}/mnt $edit $root $sqfs $cdrom' \
    0 1 2 3 15

shopt -s extglob

arch=i686
#arch=x86_64
favorite_use=
#count=4120000
count=900

url='git://github.com/falconindy/arch-install-scripts.git'
myconfig='git://github.com/ac1965/config-ac1965.git'

#iso='/boot/iso/archlinux-2013.04.01-dual.iso'
iso='/boot/iso/archlinux-2013.05.01-dual.iso'

#--
lang=ja_JP.UTF8
list_locale='\
ja_JP.UTF-8 UTF-8\
'
keymap=jp106
font=lat9w-16
font_map=8859-l_to_uni
zone='Aaia/Tokyo'
user=tjy
#--

r=/root/image
root_image=${r}/root-image.fs
log=${r}/$(basename $0 .sh).log

gdir=${r}/$(basename $url .git)
cdrom=${r}/.cdrom
sqfs=${r}/.sqfs
root=${r}/.root
edit=${r}/edit
pkgs=${r}/pkgs
pacman_d=${r}/pacman.d

bootstrap_mark=${r}/.bootstrap_finished
user_mark=${r}/.user_finished

base_pkgs='
grub-bios dialog wireless_tools iw wpa_supplicant wpa_actiond openssh alsa-utils ntp python2 git
strace nmap tcpdump lsof unzip
squashfs-tools cpio devtools libisoburn
net-tools dnsutils
jshon
'

# consolekit-git
# lib32-alsa-lib-git
favorite_pkgs='
xorg-server xf86-input-synaptics xf86-input-evdev xf86-input-mouse xf86-video-intel xorg-xinit xterm
xorg-xmodmap wmname nitrogen xorg-xsetroot xorg-xprop autocutsel xclip xscreensaver uim rxvt-unicode urxvt-perls
slim slim-themes
jdk6
chromium emacs ispell
ffmpeg cdparanoia cdrkit flac lame id3 libdvdcss
mpd-cue mpc python2-mpd
mplayer vlc abcde
acroread-ja
android-sdk-platform-tools android-udev
otf-takao ttf-sazanami ttf-ms-fonts ttf-inconsolata ttf-arphic-uming
qtile-git
ghc haskell-regex-base haskell-syb
haskell-url haskell-json haskell-curl
aura
'

out() { printf "$1 $2\n" "${@:3}"; }
error() { out "==> ERROR:" "$@"; } >&2
msg() { out "==>" "$@"; }
msg2() { out "  ->" "$@";}
die() { error "$@"; exit 1; }
dexec() {
    cmd="$@"
    msg "$cmd"
    echo "[$(date +"%D %H:%M:%S")]:Exec:$cmd" >> $log
    eval $cmd >> $log 2>&1 || die "Die:$cmd"
}

is_mount () {
    mount | grep --silent $1
    test $? -eq 0 && dexec umount $1
}

is_root_image () {
    for d in $(mount | grep $edit/.root | awk '{print $3}' | sort -r )
    do
        test x"${d}" != x"on" && dexec umount $d
    done
    for d in $(mount | grep $edit | awk '{print $3}' | sort -r )
    do
        test x"${d}" != x"on" && dexec umount $d
    done
    for d in $(mount | grep $root | awk '{print $3}' | sort -r )
    do
        test x"${d}" != x"on" && dexec umount $d
    done
    dev=$(losetup -l | grep $root_image | cut -d' ' -f1)
    losetup -l | grep --silent $root_image
    test $? -eq 0 && dexec losetup -d $dev
}

root_mount () {
    test -d $gdir || git clone $url $gdir
    (
        cd $gdir
        dexec make install
        cd - > /dev/null
    )

    is_root_image

    for d in "$@"
    do
        test -d $d || install -d $d
        is_mount $d
    done
    dexec mount $iso $cdrom
    dexec mount ${cdrom}/arch/${arch}/root-image.fs.sfs $sqfs
    dexec mount ${sqfs}/root-image.fs $root
}

umount_setup () {
    for d in "$@"
    do
        is_mount $d
    done
}

bootstrap () {
    out "[BOOTSTRAP]"
    dexec root_mount $pacman_d $pkgs $root $sqfs $cdrom
    dexec cp ${root}/etc/pacman.d/mirrorlist ${r}
    dexec mount --bind $pkgs ${root}/var/cache/pacman/pkg
    dexec mount --bind $pacman_d ${root}/etc/pacman.d
    dexec cp ${r}/mirrorlist $pacman_d
    dexec mount $root_image ${root}/mnt
    dexec arch-chroot $root pacman-key --init
    dexec arch-chroot $root pacman-key --populate archlinux
    dexec arch-chroot $root pacstrap -c /mnt base base-devel
    cat <<EOF | arch-chroot $root arch-chroot /mnt >> $log 2>&1
echo mybox > /etc/hostname
echo "LANG=$lang" > /etc/locale.conf
echo "$list_locale" > /etc/locale.gen
echo KEYMAP=$keymap > /etc/vconsole.conf
echo FONT=$font >> /etc/vconsole.conf
echo FONT_MAP=$font_map >> /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/$zone /etc/localtime
locale-gen
EOF
    dexec umount_setup ${root}/mnt ${root}/var/cache/pacman/pkg ${root}/etc/pacman.d
    dexec umount_setup $root $sqfs $cdrom
    dexec touch $bootstrap_mark
}

base_setup () {
    out "[BASE INSTALL]"
    dexec mount $root_image $edit
    dexec mount --bind $pkgs ${edit}/var/cache/pacman/pkg
    dexec mount --bind $pacman_d ${edit}/etc/pacman.d
    cat <<EOF | arch-chroot $edit >> $log 2>&1
test -f /var/lib/pacman/db.lck && rm -f /var/lib/pacman/db.lck
EOF
    dexec arch-chroot $edit pacman -Suy --noconfirm --needed
    for pkg in $base_pkgs
    do
        arch-chroot $edit pacman -Qi $pkg >/dev/null 2>&1
	case "$?" in
	    0)
		arch-chroot $edit pacman -Qu $pkg >/dev/null 2>&1
		case "$?" in
		    0) dexec arch-chroot $edit pacman -S --noconfirm --needed $pkg;;
		    1) msg2 "$pkg already updated.";;
		esac
		;;
	    1)
		dexec arch-chroot $edit pacman -S --noconfirm --needed $pkg;;
	esac
    done
    dexec umount_setup ${edit}/var/cache/pacman/pkg ${edit}/etc/pacman.d ${edit}
}

packer_setup () {
    out "[PACKER INSTALL]"
    dexec mount $root_image $edit
    dexec mount --bind $pkgs ${edit}/var/cache/pacman/pkg
    dexec mount --bind $pacman_d ${edit}/etc/pacman.d
    mydir=${edit}/root/tmp/$(basename $myconfig .git)
    test -d $mydir || dexec git clone $myconfig $mydir
    cd $mydir
    git pull
    cd - > /dev/null
    cat <<EOF | arch-chroot $edit >> $log 2>&1
cd /root/tmp/config-ac1965/archlinux/AUR
test -d packer && rm -fr packer
tar xfz packer.tar.gz
cd packer
makepkg --asroot -i --noconfirm
EOF
    dexec umount_setup ${edit}/var/cache/pacman/pkg ${edit}/etc/pacman.d ${edit}
}

favorite_setup () {
    out "[FAVORITE INSTALL]"
    dexec mount $root_image $edit
    dexec mount --bind $pkgs ${edit}/var/cache/pacman/pkg
    dexec mount --bind $pacman_d ${edit}/etc/pacman.d
    dexec arch-chroot $edit packer -Suy --noconfirm
    for pkg in $favorite_pkgs
    do
	dexec arch-chroot $edit packer -S --noconfirm $pkg
    done
    dexec umount_setup ${edit}/var/cache/pacman/pkg ${edit}/etc/pacman.d ${edit}
}

user_setup () {
    out "[USER SETUP]"
    dexec mount $root_image $edit
    dexec mount --bind $pkgs ${edit}/var/cache/pacman/pkg
    dexec mount --bind $pacman_d ${edit}/etc/pacman.d
    cat <<EOF | arch-chroot $edit >> $log 2>&1
grep --silent $user /etc/passwd || useradd -g users -G wheel -s /bin/bash $user
test -d /home/$user || git clone git://github.com/ac1965/config-ac1965.git /home/$user
cd /home/$user
git pull
cd - > /dev/null
chown -R $user:users /home/$user
EOF
grep --silent $user ${edit}/etc/passwd && (
    msg2 "Type password for $user."
    arch-chroot $edit env LANG=C passwd $user
)
    dexec umount_setup ${edit}/var/cache/pacman/pkg ${edit}/etc/pacman.d ${edit}
}

make_root () {
    out "[MAKE ROOT IMAGE]"
    lose_dev=$(losetup -f)
    msg2 "makeing ($count MB)"
    dexec dd if=/dev/zero of=$root_image bs=1M count=$count
    losetup $lose_dev $root_image
    dexec mkfs.ext4 $lose_dev
    test -f $bootstrap_mark && rm -f $bootstrap_mark
}

#--
(( $UID == 0 )) || die "This script must run as root."

export PATH=/usr/local/bin:$PATH

test -f $iso || die "$iso not found."
test -d $r || install -d $r
test -d $edit || install -d $edit
test -d $pkgs || install -d $pkgs
test -f $log && rm -f $log

clear

is_root_image
test x"$(blkid $root_image)" == x"" && make_root
test -f $bootstrap_mark && msg "Skip bootstrap package install ..." || bootstrap
base_setup
test x"$myconfig" == x"" || packer_setup
test x"$favorite_use" != x"" && favorite_setup
test -f $user_mark && msg "Skip user environment setup ..." || user_setup
