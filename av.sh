#!/bin/bash

avshCmd="adb shell am broadcast -a com.archos.mediacenter.AVSH -e cmd '$@' org.courville.nova/com.archos.mediacenter.LibAvosReceiver"
$avshCmd > /dev/null
