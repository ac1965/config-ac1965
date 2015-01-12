#! /bin/sh

for f in $(cat <<EOF
.Xresources
.bash_aliases
.bash_profile
.bashrc
.bin
.config
.gitconfig
.i3
.local
.mplayer
.music
.script
.ssh
.vim
.vimencrypt
.vimrc
.wallpaper
.weechat
.xinitrc
.zsh
.zshrc
script
tmp
EOF
); do
	echo -- $f
	cp -a $f ~
done

test -f .USERNAME_rc && cp .USERNAME_rc ~/.${USER}_rc
