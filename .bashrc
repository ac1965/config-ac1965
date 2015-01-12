# .bashrc

[ -f /etc/profile ] &&  source /etc/profile
[ -f $HOME/.profile ] && source $HOME/.profile
[ -f $HOME/.proxyuse ] && source $HOME/.proxyuse
[ -f $HOME/.chroot ] && source $HOME/.chroot
[ -f $HOME/.${USER}_rc ] && source $HOME/.${USER}_rc
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

