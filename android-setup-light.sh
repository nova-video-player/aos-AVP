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

# java8/java11/java17 paths
case `uname` in
  Linux)
    JAVA17=$(update-alternatives --list java | sed -nE -e 's/(.*java-17[^/]*).*/\1/p')
    [ -z "$JAVA17" ] && JAVA17=$(update-alternatives --list java | sed -nE -e 's/(.*jdk-17[^/]*).*/\1/p')
    [ -z "$JAVA17" ] && JAVA17=$(update-alternatives --list java | sed -nE -e 's/(.*-17[^/]*).*/\1/p')
  ;;
  Darwin)
    JAVA17=$(/usr/libexec/java_home -v 17)
  ;;
esac
[ -n "$JAVA17" ] && export PATH=${JAVA17}/bin:$PATH
echo PATH=${PATH}

export PATH=${androidSdk}/cmdline-tools/latest/bin:${androidSdk}/cmdline-tools/bin:${androidSdk}/tools/bin:$PATH

#${NDK_PATH}
#/opt/android-sdk/ndk/21.1.6352462/prebuilt/darwin-x86_64/

# android tools
#yes | sdkmanager 'cmdline-tools;latest' 'ndk;23.1.7779620' 'cmake;3.18.1' 'build-tools;30.0.3' > /dev/null

[ -d "${androidSdk}/ndk" ] && NDK_PATH=$(ls -d ${androidSdk}/ndk/* | sort -V | tail -n 1)
echo NDK_PATH is ${NDK_PATH}
export ANDROID_NDK_HOME=${NDK_PATH}
export ANDROID_NDK_ROOT=${NDK_PATH}
# latest cmake
[ -d "${androidSdk}/cmake" ] && CMAKE_PATH=$(ls -d ${androidSdk}/cmake/* | sort -V | tail -n 1)
echo CMAKE_PATH is ${CMAKE_PATH}
export PATH=$CMAKE_PATH/bin:$PATH

# make sure we use first sdk/ndk and not host tools
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
PREBUILT=prebuilt/${OS}-$(uname -m)
export PATH=${NDK_PATH}/$PREBUILT/bin:$PATH
echo PREBUILT_PATH is ${NDK_PATH}/$PREBUILT
export PATH=${NDK_PATH}/toolchains/llvm/$PREBUILT/bin:$PATH
echo LLVM_PATH is ${NDK_PATH}/toolchains/llvm/$PREBUILT
