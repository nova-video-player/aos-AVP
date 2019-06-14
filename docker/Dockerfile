FROM debian:buster
MAINTAINER Courville Software <software@courville.org>

ENV DEBIAN_FRONTEND noninteractive
ENV USER root
RUN echo "deb http://ftp.de.debian.org/debian stretch main" >> /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt update && \ 
    apt install -y locales sudo wget unzip git curl build-essential openjdk-8-jdk python pkg-config meson nasm && \
    apt clean autoclean

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# Download and install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
RUN chmod a+x /usr/local/bin/repo

RUN git config --global user.name "Courville Software"
RUN git config --global user.email "software@courville.org"

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_HOME="/opt/android-sdk" \
    ANDROID_SDK="/opt/android-sdk" \
    ANDROID_NDK="/opt/android-ndk" \
    NDK_VERSION=r19-beta2 \
    SDK_VERSION=4333796 \
    GRADLE_VERSION=4.6 \
    ANDROID_BUILD_TOOLS_VERSION=28.0.3 \
    ANDROID_VERSION=27
# Download Android SDK
RUN mkdir -p "$ANDROID_HOME" $HOME/.android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${SDK_VERSION}.zip \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses --sdk_root=${ANDROID_HOME}
# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" --sdk_root=${ANDROID_HOME}
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
RUN mkdir /opt/gradle
RUN unzip gradle-${GRADLE_VERSION}-all.zip -d /opt/gradle
ENV PATH=${PATH}:/opt/gradle/gradle-${GRADLE_VERSION}/bin
# Install NDK
RUN wget https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip
RUN unzip android-ndk-${NDK_VERSION}-linux-x86_64.zip -d /opt && mv /opt/android-ndk-${NDK_VERSION} ${ANDROID_NDK}
ENV PATH=${PATH}:${ANDROID_NDK}

RUN mkdir /nova && cd /nova && repo init -u https://github.com/nova-video-player/aos-AVP -b nova && repo sync -j 4
WORKDIR /nova

#ENTRYPOINT ["make"] 

USER root
