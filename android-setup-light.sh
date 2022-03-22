#!/bin/bash

case `uname` in
  Linux)
    READLINK=readlink
    SED=sed
    export CORES=$((`nproc`+1))
  ;;
  Darwin)
    # assumes brew install coreutils in order to support readlink -f on macOS
    READLINK=greadlink
    SED=gsed
    export CORES=$((`sysctl -n hw.logicalcpu`+1))
  ;;
esac

# android sdk directory is changing
[ -n "${ANDROID_HOME}" ] && androidSdk=${ANDROID_HOME}
[ -n "${ANDROID_SDK}" ] && androidSdk=${ANDROID_SDK}
[ -n "${ANDROID_SDK_ROOT}" ] && androidSdk=${ANDROID_SDK_ROOT}

# java8/java11 paths
case `uname` in
  Linux)
    JAVA11=$(update-alternatives --list java | sed -nE -e 's/(.*java-11[^/]*).*/\1/p')
    [ -z "$JAVA11" ] && JAVA8=$(update-alternatives --list java | sed -nE -e 's/(.*jdk-11[^/]*).*/\1/p')
  ;;
  Darwin)
    JAVA11=$(/usr/libexec/java_home -v 11)
  ;;
esac
[ -n "$JAVA11" ] && export PATH=${JAVA11}/bin:$PATH

# android tools
yes | sdkmanager 'cmdline-tools;latest' \
  'ndk;23.1.7779620' \
  'cmake;3.18.1' \
  platform-tools \
  'build-tools;30.0.3' > /dev/null

[ -d "${androidSdk}/ndk" ] && NDK_PATH=$(ls -d ${androidSdk}/ndk/* | sort -V | tail -n 1)
echo NDK_PATH is ${NDK_PATH}
export ANDROID_NDK_HOME=${NDK_PATH}
export ANDROID_NDK_ROOT=${NDK_PATH}
# latest cmake
[ -d "${androidSdk}/cmake" ] && CMAKE_PATH=$(ls -d ${androidSdk}/cmake/* | sort -V | tail -n 1)
echo CMAKE_PATH is ${CMAKE_PATH}
