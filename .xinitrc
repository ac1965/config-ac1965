#!/bin/sh
#
# ~/.xinitrc
#

exec > ~/.xsession-errors 2>&1

# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# language and keyboard layout
export LANG=ja_JP.UTF8
setxkbmap -layout jp -option ctrl:nocaps -option terminate:ctrl_alt_bksp

# systemctl --user enable mpd
export MPD_HOST=localhost
#export MPD_HOST=192.168.3.101
export MPD_PORT=6600
export GTK_IM_MODULE='uim'
export XMODIFIERS='@im=uim'
export QT_IM_MODULE='uim'

xrdb -merge ~/.Xresources
xrandr --output LVDS1 --primary
xsetroot -cursor_name top_left_arrow
autocutsel -fork
autocutsel -selection PRIMARY -fork

#
if [[ -x $(type -p gnome-keyring-daemon) ]]; then
    eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"
    export GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID
fi

# if proxy environment
[[ -f "$HOME/.proxyuse" ]] && source "$HOME/.proxyuse"

case "$1" in
    i3) ~/.i3/i3.sh;;
esac

exec $1 > .config/.wm.log 2> .config/.wm-errors.log

kill $GNOME_KEYRING_PID
