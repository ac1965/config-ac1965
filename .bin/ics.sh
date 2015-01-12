#! /bin/bash

url=git://github.com/IceColdSandwich/android.git
branch_name=ics
name=lord

export ANDROID=$HOME/android
export LOG=$ANDROID/${branch_name}_${name}.log
export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache
export ICS=$ANDROID/ICoS
export JAVA_HOME=$HOME/jdk1.6.0_32

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

if [ -d $ICS/.repo ]; then
    cd $ICS
    einfo $(pwd)
    case "$1" in
        --skip-repo-sync|--skip|-s)
            ;;
        *)
            dexec repo sync -j16
            ;;
    esac
else
    test -d $ICS || install -d $ICS
    cd $ICS
    einfo "initial $(pwd)"
    dexec repo init -u $url -b $branch_name
    dexec repo sync -j16
fi

dexec make clobber
dexec prebuilt/linux-x86/ccache/ccache -M 40G
dexec . build/envsetup.sh
dexec time lunch htc_ace-userdebug
dexec time make -j${cpuinfo} $name
#make -j${cpuinfo} $name TARGET_TOOLS_PREFIX=prebuilt/linux-x86/toolchain/arm-eabi-4.6.3/bin/arm-linux-androideabi-

cd - > /dev/null
