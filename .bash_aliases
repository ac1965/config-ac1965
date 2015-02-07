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

if [[ $(type -p nvim) ]]; then
    alias vi="nvim"
elif [[ $(type -p vim) ]]; then
    alias vi="vim"
fi

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

# pacman tips
alias pacupg='sudo pacman -Syu'         # Synchronize with repositories and then upgrade packages that are out of date on the local system.
alias pacin='sudo pacman -S'            # Install specific package(s) from the repositories
alias pacins='sudo pacman -U'           # Install specific package not from the repositories but from a file
alias pacre='sudo pacman -R'            # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem='sudo pacman -Rns'         # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep='pacman -Si'               # Display information about a given package in the repositories
alias pacreps='pacman -Ss'              # Search for package(s) in the repositories
alias pacloc='pacman -Qi'               # Display information about a given package in the local database
alias paclocs='pacman -Qs'              # Search for package(s) in the local database
alias paclo="pacman -Qdt"               # List all packages which are orphaned
alias pacc="sudo pacman -Scc"           # Clean cache - delete all not currently installed package files
alias paclf="pacman -Ql"                # List all files installed by a given package
alias pacexpl="pacman -D --asexp"       # Mark one or more installed packages as explicitly installed
alias pacimpl="pacman -D --asdep"       # Mark one or more installed packages as non explicitly installed

# '[r]emove [o]rphans' - recursively remove ALL orphaned packages
alias pacro="pacman -Qtdq > /dev/null && sudo pacman -Rns \$(pacman -Qtdq | sed -e ':a;N;$!ba;s/\n/ /g')"

# Additional pacman alias examples
alias pacupd='sudo pacman -Sy && sudo abs'         # Update and refresh the local package and ABS databases against repositories
alias pacinsd='sudo pacman -S --asdeps'            # Install given package(s) as dependencies
alias pacmir='sudo pacman -Syy'                    # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

# dealing with the following message from pacman:
#
#     error: couldnt lock database: file exists
#     if you are sure a package manager is not already running, you can remove /var/lib/pacman/db.lck

alias pacunlock="sudo rm /var/lib/pacman/db.lck"   # Delete the lock file /var/lib/pacman/db.lck
alias paclock="sudo touch /var/lib/pacman/db.lck"  # Create the lock file /var/lib/pacman/db.lck
