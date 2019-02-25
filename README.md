### NOVA: opeN sOurce Video plAyer

[![NOVA Community](https://img.shields.io/badge/join-community-blue.svg)](https://www.reddit.com/r/NovaVideoPlayer)
[![API](https://img.shields.io/badge/API-21%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=21)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/Apache-2.0)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://github.com/nova-video-player/aos-AVP/blob/nova/LICENSE.txt)
[![Crowdin](https://crowdin.net/badges/nova-video-player/localized.png)](https://crowdin.com/project/nova-video-player)
[![Get it on Google Play](https://badgen.net/badge/Get%20it%20on/Google%20Play/689f38?icon=googleplay)](https://play.google.com/store/apps/details?id=org.courville.nova)
[![Chat on irc](https://img.shields.io/badge/irc.freenode.net-%23novavideoplayer-blue.svg)](https://webchat.freenode.net)
[![Downloads](https://img.shields.io/github/downloads/nova-video-player/aos-AVP/total.svg)](https://github.com/nova-video-player/aos-AVP/releases)
[![Build Status](https://img.shields.io/travis/nova-video-player/aos-Fdroid.svg)](https://travis-ci.org/nova-video-player/aos-Fdroid)
[![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/NovaVideoPlayer/donate)

#### Overview

NOVA is an open source video player for Android. It consists in a fork of the original Archos Video Player Community Edition that is hosted here: https://github.com/archos-sa/aos-AVP intended to support new features.

This is the entry point repo. It purpose is to provide the manifest to fetch all needed git repos with sources and then bootstrap the build environment.

More interesting sources can be found there:
- Video https://github.com/nova-video-player/aos-Video
- MediaLib https://github.com/nova-video-player/aos-MediaLib
- FileCoreLibrary  https://github.com/nova-video-player/aos-FileCoreLibrary
- avos https://github.com/nova-video-player/aos-avos

For the full list, please look at this manifest https://github.com/nova-video-player/aos-AVP/default.xml

#### Building

Get the repo tool (https://source.android.com/source/downloading), then type:
```
mkdir aos; cd aos
repo init -u https://github.com/nova-video-player/aos-AVP -b nova
repo sync -j4
repo forall -c 'git checkout -t $REPO_REMOTE/$REPO_RREV'
make
```

Alternatively for those not under Linux with a properly installed Android SDK/NDK, you can launch the video player build through:
```
cd Video
./gradlew assembleCommunityLeanbackNoamazonPrivlibs
```

Note that build is performed on local git clone of ffmpeg and dav1d repos and in order to trigger full update rebuild, you need in case of version upstep to manually do:
```
cd native/dav1d-android-builder; git clean -fdx; cd ..
cd native/ffmpeg-android-builder; git clean -fdx; cd ..
```

Please note that the following packages are required to build:
```
sudo curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
sudo chmod a+x /usr/local/bin/repo
sudo apt install build-essential wget curl unzip openjdk-8-jdk python git pkg-config meson nasm
```

Alternatively you can use the provided docker image to build nova:
```
cd nova/AVP/docker
docker build -t nova .
docker run --rm -ti --entrypoint=/bin/bash nova
make
```
#### Latest stable apk

The compiled application is available for installation on Google Play: https://play.google.com/store/apps/details?id=org.courville.nova

[<img src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png" alt="Get it on Google Play" height="80">](https://play.google.com/store/apps/details?id=org.courville.nova)

or on Amazon Appstore: https://www.amazon.fr/dp/B07P1Q1DG9

[<img src="https://images-na.ssl-images-amazon.com/images/G/01/mobile-apps/devportal2/res/images/amazon-appstore-badge-english-black.png" alt="Get it on Amazon Appstore" height="80">](http://www.amazon.com/gp/mas/dl/android?p=org.courville.nova)

Releases are also published on github: https://github.com/nova-video-player/aos-AVP/releases

#### Scraping and Scrobbling

Scraping and scrobbling features rely on external services such as **TMDb** (https://www.themoviedb.org/), **TheTVDB** (http://thetvdb.com/) and **Trakt** (https://trakt.tv).

In order to enable NOVA video player to perform these tasks you need to register to this services and enable the API and inject the corresponding keys inside the following files: *MediaLib/src/community/res/values/donottranslate.xml*
replacing the fake values below:
```xml
    <?xml version="1.0" encoding="utf-8"?>
    <resources xmlns:android="http://schemas.android.com/apk/res/android">
        <string name="tvdb_api_key">0123456789ABCDEF</string>
        <string name="tmdb_api_key">0123456789abcdef0123456789abcdef</string>
        <string name="trakt_api_key">0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef</string>
        <string name="trakt_api_secret">0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef</string>
    </resources>
```

Please note that enabling **TheTVDB** API registration can be completed following this link: https://www.thetvdb.com/?tab=apiregister


To create a **Trakt** api, first register to trakt then add a new app
https://trakt.tv/oauth/applications

Redirect URI should be
http://localhost
and be aware to grant all permissions.

#### Localization

You are welcome to contribute to the translation of the application at https://crowdin.com/project/nova-video-player

#### Donate

You are always welcome to show your gratitude and appreciation to the developers of this application through a donation via liberapay 
[![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/NovaVideoPlayer/donate).

Please bare in mind that the work carried out here results from a small community effort done with good will on scarce personal time.
If need be, we might in the future introduce some extra bounty programs for specific feature development requests.

#### Support community and chat room

[NovaVideoPlayer reddit community](https://www.reddit.com/r/NovaVideoPlayer) community is used as the support community for the Nova Video Player application.
It is possible to chat with Nova Video Player developers on #novavideoplayer freenode IRC channel (https://webchat.freenode.net).

