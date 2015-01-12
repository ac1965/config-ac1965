#! /bin/bash

[ "$EMACS" == "t" ] || alias ls="ls --color"

export PAGER=less

alias ali="alias"

alias emac="emacs -nw -q --no-site-file"
alias ri="ri -f ansi -T"

alias ll="ls -l -h"
alias la="ls -a"
alias l="ls"
alias lla="ls -a -l"
alias grep="grep --color=auto"
alias grepp="ps aux | grep"
alias vi="vim"
#@alias man="LANG=ja_JP.EUC-JP man"

if [ $UID -eq 0 ]; then
    alias emi="emerge -av --jobs=4 --load-average=11"
    alias emr="emerge -aC"
    alias pacman="pacman"
    alias iw="/root/.script/iwconfig.sh"
    alias luks="/root/script/luks.sh"
else
    alias emi="sudo emerge -av --jobs=4 --load-average=11"
    alias emr="sudo emerge -aC"
    alias pacman="sudo pacman"
    alias iw="sudo iwconfig.sh"
    alias luks="sudo luks.sh"
fi
# package management
alias yaourt="yaourt"

# gems
alias agi="gem install"
alias agr="gem uninstall"
alias agd="gem source -u"
alias agc="gem search --remote"

# git
alias gst="git status"
alias gb="git branch --color"
alias gcm="git commit -a -v"
alias gph="git push"
alias gco="git checkout"
alias genago="genlop -l --date 1 days ago"

alias xmlcurl="curl -H Accept:text/xml"
alias guruplug="screen /dev/ttyUSB0 115200"
