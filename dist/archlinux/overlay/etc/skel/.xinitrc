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

# MPD startup
[[ -x $(type -p mpd) ]] && \
    test -f ~/.config/mpd/pid && (mpd --kill && mpd) || mpd

## Change keyboarmap
#[[ -x $(type -p xmodmap) ]] && (
#    xmodmap -e "remove Lock = Caps_Lock"
#    xmodmap -e "add Control = Caps_Lock"
#    xmodmap -e "keysym Caps_Lock = Control_L"
#    xmodmap -e "clear mod3"
#    xmodmap -e "add mod3 = Muhenkan"
#)

desktop=$1
SESSION=

run_dwm(){
  xcompmgr -c -f -D 5 &
  xscreensaver --no-splash &
  SESSION=dwm
}

run_spectrmw(){
  xcompmgr -c -f -D 5 &
  xscreensaver --no-splash &
  SESSION=spectrmw
}

run_openbox(){
  SESSION=openbox-session
}

run_i3(){
  sh ~/.i3/i3.sh
  SESSION=i3
}


if [[ $desktop == dwm ]]; then
      run_dwm
elif [[ $desktop == spectrwm ]]; then
      run_spectrwm
elif [[ $desktop == openbox ]]; then
      run_openbox
else
      run_i3
fi

exec $SESSION > .config/.wm.log 2> .config/.wm-errors.log

kill $GNOME_KEYRING_PID
