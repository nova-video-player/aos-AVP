#!/bin/bash

# this script generates the pathPattern lines for intent-filter part of AndroidManifest.xml for all video file extensions
# such ugly explicit matching is required because Android primitive PatternMatcher where <data android:pathPattern=".*\\.mkv" />
# stops matching at the first '.' encountered...
# Note to self: get the list vi style :.,$s/.*\\\\\.\([^\."]*\)".*$/\1/g
for ext in 3g2 3gp 3gp2 3gpp asf avi divx flv f4v qt m4v mtv mkv mp4 mpeg mpe mpg mov ogm ogv ogx vob wtv webm 3G2 3GP 3GP2 3GPP ASF AVI DIVX FLV F4V QT M4V MTV MKV MP4 MPEG MPE MPG MOV OGV VOB WTV WEBM
do
  echo "<data android:pathPattern=\".*\\\\.${ext}\" />
<data android:pathPattern=\".*\\\\..*\\\\.${ext}\" />
<data android:pathPattern=\".*\\\\..*\\\\..*\\\\.${ext}\" />
<data android:pathPattern=\".*\\\\..*\\\\..*\\\\..*\\\\.${ext}\" />
<data android:pathPattern=\".*\\\\..*\\\\..*\\\\..*\\\\..*\\\\.${ext}\" />
<data android:pathPattern=\".*\\\\..*\\\\..*\\\\..*\\\\..*\\\\..*\\\\.${ext}\" />
<data android:pathPattern=\".*\\\\..*\\\\..*\\\\..*\\\\..*\\\\..*\\\\..*\\\\.${ext}\" />" >> liste
done



