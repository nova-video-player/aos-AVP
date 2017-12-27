#!/bin/bash

avshCmd="adb shell am broadcast -a com.archos.mediacenter.AVSH -e cmd '$@'"
$avshCmd > /dev/null
