#!/bin/bash

version=$1
major=`echo $version | cut -d. -f1`
minor=`echo $version | cut -d. -f2`
prefix=/agraver/git/nova
avp=$prefix/AVP
cd $avp
git tag -a "v${major}.${minor}" -m "v${major}.${minor} new google play public release"
git push --tags

echo "Uploading release v${major}.${minor} to github..."

cd $prefix/Video
bdir=$prefix/Video/build/outputs/apk/communityLeanbackNoamazonPrivlibs/release
mkdir -p $bdir
repo manifest -r > $bdir/manifest-new.xml

ret=0
#launch build only if manifests are not the same
if [ `diff -q $bdir/manifest.xml $bdir/manifest-new.xml | grep -qE .` ]
then
  ./gradlew aCLNPR || ret = 1
  [ -f $bdir/manifest.xml ] && mv $bdir/manifest.xml $bdir/manifest-old.xml
  mv $bdir/manifest-new.xml $bdir/manifest.xml
else
  ret=1
fi
if [ "$ret" == "1" ]
then
  cd $prefix/AVP/release
  ./push.py "v${major}.${minor}" "v${major}.${minor} Google Play release" $bdir
fi
