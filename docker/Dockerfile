FROM debian:bullseye
MAINTAINER Courville Software <software@courville.org>

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

# install build tools
RUN echo "Install Linux build environment"
RUN apt update && apt upgrade --yes --assume-yes
RUN apt install -y nasm ninja-build maven build-essential \
        file git wget curl unzip sudo pkg-config \
        python3 python3-pip python3-setuptools python3-wheel \
        openjdk-11-jdk \
        tig vim-tiny less screen

# install openjdk-8-jdk
RUN apt install -y apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key --keyring /etc/apt/trusted.gpg.d/adoptopenjdk-apt-key.gpg add
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt update && apt install -y adoptopenjdk-8-hotspot

# use python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN apt clean autoclean
RUN pip3 install meson==0.53.2

# download and install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo | sudo tee /usr/local/bin/repo > /dev/null
RUN chmod a+x /usr/local/bin/repo

# set proper env variables
ENV ANDROID_SDK_TOOLS=7583922 \
    OS=linux \
    SDK_URL="https://dl.google.com/android/repository"

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV SDKMANAGER="$ANDROID_SDK_ROOT/cmdline-tools/tools/bin"

ENV NDKVER=21
ENV BUILDTOOLSVER=31

ENV PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin"

# download minimal Android SDK/NDK

RUN echo "Install minimal Android SDK" && \
    wget --quiet --output-document=/opt/android-cmdline.zip ${SDK_URL}/commandlinetools-${OS}-${ANDROID_SDK_TOOLS}_latest.zip && \
    unzip -q /opt/android-cmdline.zip -d /opt && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    mv /opt/cmdline-tools /opt/android-sdk/cmdline-tools/tools

RUN echo "Install Android NDK" && \
    ndk=$(pkg="ndk;$NDKVER"; sdkmanager --list | grep ${pkg} | sed "s/^.*\($pkg\.[0-9\.]*\) .*$/\1/g" | tail -n 1) && \
    yes | sdkmanager "${ndk}" > /dev/null

RUN echo "Fetch nova source code" && \
    mkdir -p /nova && \
    cd /nova && \
    repo init -u https://github.com/nova-video-player/aos-AVP -b nova -m v6.xml && \
    repo sync -j 4 && \
    repo forall -c 'git checkout -t $REPO_REMOTE/$REPO_RREV' 

WORKDIR /nova

#ENTRYPOINT ["make"] 

USER root
