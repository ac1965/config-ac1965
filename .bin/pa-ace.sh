#! /bin/bash

# repo init -u https://github.com/AOKP/platform_manifest.git -b jb
# git clone git://github.com/codefire-ace/android.git -b aokp-jb

url=git://github.com/CyanogenMod/android.git
branch_name=jellybean
#@use_local_url=https://raw.github.com/codefireX/android/jellybean/local_manifest.xml
use_local_url=https://raw.github.com/pa-ace/android/jellybean-legacy/ace_manifest.xml
name=pa-ace

export ANDROID=$HOME/android
export LOG=$ANDROID/${branch_name}-${name}.log
export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache
export JB=$ANDROID/pa-ace
#export JAVA_HOME=$HOME/jdk1.6.0_32

die() {
    echo -e "\033[1;30m>\033[0;31m>\033[1;31m> ERROR:\033[0m ${@}"
    exit 1
}

einfo() {
    echo -ne "\033[1;30m>\033[0;36m>\033[1;36m> \033[0m${@}\n"
}

ewarn() {
    echo -ne "\033[1;30m>\033[0;33m>\033[1;33m> \033[0m${@}\n"
}

dexec () {
    CMD="$@"
    einfo "Exec:$CMD"
    echo "[$(date +"%D %H:%M:%S")]:Exec:$CMD" >> $LOG
    eval $CMD >> $LOG 2>&1 || die "Die:$CMD"
}

test -f $LOG && mv $LOG $LOG.prev
cpuinfo=$(grep -i processor /proc/cpuinfo | wc -l)

if [ -d $JB/.repo ]; then
    cd $JB
    einfo $(pwd)
    case "$1" in
        --skip-repo-sync|--skip|-s)
            test $use_local_url != "" && dexec curl -s -o .repo/local_manifest/$use_local_url $use_local_url
            ;;
        *)
            test $use_local_url != "" && dexec curl -s -o .repo/local_manifest/$use_local_url $use_local_url
            dexec time repo sync -j16
            ;;
    esac
else
    test -d $JB || install -d $JB
    cd $JB
    einfo "initial $(pwd)"
    dexec repo init -u $url -b $branch_name
    test -d .repo/local_manifest || install -d .repo/local_manifest
    test $use_local_url != "" && dexec curl -s -o .repo/local_manifest/$(basename  $use_local_url) $use_local_url
    dexec time repo sync -j16
fi

dexec time ./vendor/cm/get-prebuilts
dexec time make clobber
dexec ccache -M 40G
dexec . build/envsetup.sh
dexec time lunch cm_ace-userdebug
dexec time make -j${cpuinfo} bacon

cd - > /dev/null
