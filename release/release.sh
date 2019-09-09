#!/bin/bash

version=$1
major=`echo $version | cut -d. -f1`
minor=`echo $version | cut -d. -f2`
cd ../..
prefix=`pwd`
avp=$prefix/AVP
cd $avp
#git tag -a "v${major}.${minor}" -m "v${major}.${minor} release"
#git push --tags
repo forall -c git tag -a "v${major}.${minor}" -m "v${major}.${minor} release"
repo forall -c git push --tags

echo "Uploading release v${major}.${minor} to github..."

cd $prefix/Video
bdir=$prefix/Video/build/outputs/apk/noamazon/release
mkdir -p $bdir
repo manifest -r > $bdir/manifest-new.xml

ret=0
#launch build only if manifests are not the same
#if [ `diff -q $bdir/manifest.xml $bdir/manifest-new.xml | grep -qE .` ]
#then
#  ./gradlew aNR || ret = 1
  [ -f $bdir/manifest.xml ] && mv $bdir/manifest.xml $bdir/manifest-old.xml
#else
  ret=1
#fi
if [ "$ret" == "1" ]
then
  mv $bdir/manifest-new.xml $bdir/manifest.xml
  cd $prefix/AVP/release
  ./push.py "v${major}.${minor}" "v${major}.${minor} release" $bdir
fi
