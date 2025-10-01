# NOVA: opeN sOurce Video plAyer

## Overview

NOVA is an open source video player for Android. It consists in a fork of the original Archos Video Player Community Edition that is hosted here: https://github.com/archos-sa/aos-AVP intended to support new features.

Before asking any question please make sure that you have read the application [FAQ](https://github.com/nova-video-player/aos-AVP/blob/nova/faq/faq.md).

This is the entry point repo. Its purpose is to provide the manifest to fetch all needed git repos with sources and then bootstrap the build environment.

More interesting sources can be found there:
- [Video](https://github.com/nova-video-player/aos-Video): nova's Video UI code
- [MediaLib](https://github.com/nova-video-player/aos-MediaLib): nova's media library management code
- [FileCoreLibrary](https://github.com/nova-video-player/aos-FileCoreLibrary): nova's file management code
- [avos](https://github.com/nova-video-player/aos-avos): C core multimedia engine using ffmpeg

For the full list, please look at this manifest https://github.com/nova-video-player/aos-AVP/default.xml

## Building

Get the [repo tool](https://source.android.com/source/downloading), then type:
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

Note that the following packages are required to build:
```
sudo curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
sudo chmod a+x /usr/local/bin/repo
sudo apt install build-essential python3 python3-pip python3-setuptools ninja-build maven file wget curl unzip git pkg-config meson nasm openjdk-17-jdk-headless openjdk-8-jdk-headless
```

Alternatively, you can use the provided docker image to build nova:
```
cd nova/AVP/docker
docker build -t nova .
docker run --rm -ti --entrypoint=/bin/bash nova
make
```

Github workflow build configuration file is also provided [here](https://github.com/nova-video-player/aos-Video/blob/v6.2/.github/workflows/nova.yml)

## Latest stable apk

The compiled application is available for installation on:

But for me the best way to get the latest nova video player apk is through [obtainium](https://github.com/ImranR98/Obtainium) which I recommend to use.

## Scraping and Scrobbling

Scraping and scrobbling features rely on external services such as [**TMDb**](https://www.themoviedb.org/) and [**Trakt**](https://trakt.tv).

Please note that enabling **TMDB** API registration can be completed following this [link](https://www.themoviedb.org/settings/api).

To create a **Trakt** api, first register to trakt then add a new app [here](https://trakt.tv/oauth/applications).

Redirect URI should be http://localhost and be aware to grant all permissions.

## Localization

You are welcome to contribute to the translation of the application using crowdin platform [here](https://crowdin.com/project/nova-video-player).

## Donate

Any contribution to show your gratitude and appreciation is always welcome, keeping the small team of developers working on their personal time motivated and aware that their dedication means something.

Funds collected are essentially used to buy devices on which problems are reported for analysis and fix in order to cope with Android fragmentation.

Please bear in mind that the work carried out here results from a small community effort done with good will on scarce personal time.
If need be, we might in the future introduce some extra bounty programs for specific feature development requests.

## Support community and chat room

[NovaVideoPlayer reddit community](https://www.reddit.com/r/NovaVideoPlayer) community is used as the support community for the Nova Video Player application.
It is possible to chat with Nova Video Player developers on [#novavideoplayer liberachat IRC channel](https://web.libera.chat/).

