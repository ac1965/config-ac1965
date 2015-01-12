#! /bin/sh

base="${HOME}/android"
rom="cfx"
wdir=${base}/${rom}
# git clone https://bitbucket.org/codefirex/android.git
repo="https://bitbucket.org/codefirex/android.git"
branch="jb-devel"
test -d $wdir  || install -d $wdir

cd $base
if [ ! -d ${base}/.repo ]; then
	repo init -u $repo -b $branch
fi
repo sync
cd - > /dev/null
