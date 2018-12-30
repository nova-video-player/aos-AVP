### NOVA: opeN sOurce Video plAyer

[![NOVA Community](https://img.shields.io/badge/join-community-blue.svg)](https://plus.google.com/communities/101947888493799161313)
[![API](https://img.shields.io/badge/API-17%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=17)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/Apache-2.0)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://github.com/amitshekhariitbhu/Android-Debug-Database/blob/master/LICENSE)

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
make
```

Alternatively for those not under Linux with a properly installed Android SDK/NDK, you can launch the build for one of the flavors of the video player through:
```
cd Video
./gradlew assembleCommunityLeanbackNoamazonPrivlibs
```
#### Latest stable apk

The compiled application is available for installation on Google Play: https://play.google.com/store/apps/details?id=org.courville.nova
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

