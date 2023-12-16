#!/bin/bash

#version=$1
version=$(grep " versionName = '" ../../Video/build.gradle | sed "s/^.*versionName = '\([0-9\.]*\)'.*$/\1/g")
major=$(echo $version | cut -d. -f1)
minor=$(echo $version | cut -d. -f2)
patch=$(echo $version | cut -d. -f3)
echo version ${major}.${minor}.${patch}

case `uname` in
  Linux)
    export CORES=$((`nproc`+1))
  ;;
  Darwin)
    # assumes brew install coreutils in order to support readlink -f on macOS
    export CORES=$((`sysctl -n hw.logicalcpu`+1))
  ;;
esac

cd ../..
prefix=`pwd`
avp=$prefix/AVP
cd $avp

echo "Uploading release v${version} to github..."

cd $prefix/Video
bdir=$prefix/Video/build/outputs/apk/noamazon/release
mkdir -p $bdir

ret=0
./gradlew -Poneapk -PbugReport -Psponsor -PadultScrape aNR --parallel --max-workers=${CORES} && ret=1
echo "build result: $ret"
if [ "$ret" == "1" ]
then
  repo manifest -r > $bdir/manifest.xml
  cd $prefix/AVP/release
  ls $bdir
  echo uploading
  ./push.py "v${version}" "v${version} release" $bdir
fi
