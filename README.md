### NOVA: opeN sOurce Video plAyer

[![Reddit Nova Community](https://img.shields.io/reddit/subreddit-subscribers/novavideoplayer?style=social)](https://www.reddit.com/r/NovaVideoPlayer/)
[![API](https://img.shields.io/badge/API-21%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=21)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/Apache-2.0)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://github.com/nova-video-player/aos-AVP/blob/nova/LICENSE.txt)
[![Crowdin](https://badges.crowdin.net/nova-video-player/localized.svg)](https://crowdin.com/project/nova-video-player)
[![Get it on Google Play](https://badgen.net/badge/Get%20it%20on/Google%20Play/689f38?icon=googleplay)](https://play.google.com/store/apps/details?id=org.courville.nova)
[![Get it on Amazon Appstore](https://badgen.net/badge/Get%20it%20on/Amazon%20Appstore/689f38)](https://www.amazon.fr/dp/B07P1Q1DG9)
[![Get it on F-Droid](https://img.shields.io/f-droid/v/org.courville.nova)](https://f-droid.org/packages/org.courville.nova)
[![Chat on irc](https://img.shields.io/badge/irc.libera.chat-%23novavideoplayer-blue.svg)](https://web.libera.chat/)
[![Github Downloads](https://img.shields.io/github/downloads/nova-video-player/aos-AVP/total.svg)](https://github.com/nova-video-player/aos-AVP/releases)
![Build status](https://github.com/nova-video-player/aos-Video/workflows/NOVA%20CI/badge.svg)
[![Donate](https://img.shields.io/badge/liberapay-donate-yellow.svg?logo=liberapay)](https://liberapay.com/NovaVideoPlayer/donate)


#### Overview

NOVA is an open source video player for Android. It consists in a fork of the original Archos Video Player Community Edition that is hosted here: https://github.com/archos-sa/aos-AVP intended to support new features.

This is the entry point repo. Its purpose is to provide the manifest to fetch all needed git repos with sources and then bootstrap the build environment.

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

Alternatively, for those not under Linux with a properly installed Android SDK/NDK, you can launch the video player build through:
```
cd Video
./gradlew -Puniversal assembleNoamazonRelease
```

In order to speed up the build, build is performed using dav1d, ffmpeg and other pre-built binaries and using local git clone of ffmpeg and dav1d repos. In order to trigger full update rebuild, you need in case of version upstep to manually do:
```
rm -rf native/torrentd/libs
cd native/dav1d-android-builder; git clean -fdx; rm -rf built-*
cd native/ffmpeg-android-builder; git clean -fdx; rm -rf dist-*
```

Note that the following packages are required to build:
```
sudo curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
sudo chmod a+x /usr/local/bin/repo
sudo apt install build-essential wget curl unzip openjdk-8-jdk python git pkg-config meson nasm
```

Recent versions of nasm (≥2.13) and meson (≥0.47) are now required for building ffmpeg/dav1d.
Nasm can be installed with:
```
wget http://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
tar xjvf nasm-2.14.02.tar.bz2
cd nasm-2.14.02
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure
PATH="$HOME/bin:$PATH" make
sudo make install
```
Latest meson can be installed via:
```
sudo apt install -y pkg-config python3 python3-pip python3-setuptools ninja-build
sudo pip3 install --upgrade pip
pip3 install --user meson==0.53.2
```

Alternatively, you can use the provided docker image to build nova:
```
cd nova/AVP/docker
docker build -t nova .
docker run --rm -ti --entrypoint=/bin/bash nova
make
```

Travis-ci build configuration file is also provided here: https://github.com/nova-video-player/aos-Fdroid/blob/master/.travis.yml

Binaries prebuilt of torrentd, ffmpeg, dav1d have been committed in order to reduce compilation time and remove nasm, meson dependencies. If you need to regenerate torrentd, ffmpeg and dav1d libs, please run `make clean_prebuilt`.

#### Latest stable apk

The compiled application is available for installation on Google Play: https://play.google.com/store/apps/details?id=org.courville.nova

[<img src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png" alt="Get it on Google Play" height="80" align="center">](https://play.google.com/store/apps/details?id=org.courville.nova)

or on Amazon Appstore: https://www.amazon.fr/dp/B07P1Q1DG9 

[<img src="https://images-na.ssl-images-amazon.com/images/G/01/mobile-apps/devportal2/res/images/amazon-appstore-badge-english-black.png" alt="Get it on Amazon Appstore" height="50" align="center">](http://www.amazon.com/gp/mas/dl/android?p=org.courville.nova)

or on F-Droid https://f-droid.org/packages/org.courville.nova

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80" align="center">](https://f-droid.org/packages/org.courville.nova)

or on Huawei AppGallery https://appgallery.huawei.com/#/app/C102811509

[<img src="https://seeklogo.com/images/E/explore-it-on-huawei-appgallery-logo-64D5BB09B6-seeklogo.com.png" alt="Get it on Huawei AppGallery" height="80" align="center">](https://appgallery.huawei.com/#/app/C102811509)

Releases are also published on github: https://github.com/nova-video-player/aos-AVP/releases

#### Scraping and Scrobbling

Scraping and scrobbling features rely on external services such as **TMDb** (https://www.themoviedb.org/), **TheTVDB** (http://thetvdb.com/) and **Trakt** (https://trakt.tv).

In order to enable NOVA video player to perform these tasks, you need to register to this services and enable the API and inject the corresponding keys inside the following files: *MediaLib/src/community/res/values/donottranslate.xml*
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

Any contribution to show your gratitude and appreciation is always welcome, keeping the small team of developers working on their personal time motivated and aware that their dedication means something.

Three main platforms are proposed for that purpose: [liberapay](https://liberapay.com/NovaVideoPlayer/donate), [github sponsor](https://github.com/sponsors/courville) and [opencollective](https://opencollective.com/novavideoplayer).

Funds collected are essentially used to buy devices on which problems are reported for analysis and fix in order to cope with Android fragmentation.

Please bear in mind that the work carried out here results from a small community effort done with good will on scarce personal time.
If need be, we might in the future introduce some extra bounty programs for specific feature development requests.

#### Support community and chat room

[NovaVideoPlayer reddit community](https://www.reddit.com/r/NovaVideoPlayer) community is used as the support community for the Nova Video Player application.
It is possible to chat with Nova Video Player developers on #novavideoplayer liberachat IRC channel (https://web.libera.chat/).

