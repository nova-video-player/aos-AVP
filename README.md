### AVP -- Archos Video Player Community Edition

#### Overview

This open source release is a public release that differs from its ancestor, Archos Video Player (https://play.google.com/store/apps/details?id=com.archos.mediacenter.video)
It should nevertheless offer feature parity.

A video player software for Android

This is the entry point repo, it's purpose is to provide the manifest to fetch all needed git repos with sources and then bootstrap the build environment.

More interesting sources can be found in:
- Video https://github.com/archos-sa/aos-Video
- MediaLib https://github.com/archos-sa/aos-MediaLib
- FileCoreLibrary  https://github.com/archos-sa/aos-FileCoreLibrary
- avos https://github.com/archos-sa/aos-avos

For the full list, please look at https://github.com/archos-sa/aos-AVP/default.xml

#### Building

Get the repo tool (https://source.android.com/source/downloading), then type:
```
mkdir aos; cd aos
repo init -u https://github.com/archos-sa/aos-AVP
repo sync -j4
make
```

Alternatively for those not under Linux with a properly installed Android SDK/NDK, you can launch the build for one of the flavors of the video player through:
```
cd Video
./gradlew assembleCommunityLeanbackNoamazonPrivlibs
```
#### Scraping and Scrobbling

Scraping and scrobbling features rely on external services such as **TMDb** (https://www.themoviedb.org/), **TheTVDB** (http://thetvdb.com/) and **Trakt** (https://trakt.tv).

In order to enable Archos video player to perform these tasks you need to register to this services and enable the API and inject the corresponding keys inside the following files: *MediaLib/src/community/res/values/donottranslate.xml*
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

Please note that enabling **TheTVDB** API registration can be completed following this link: http://thetvdb.com/?tab=api


To create a **Trakt** api, first register to trakt then add a new app
https://trakt.tv/oauth/applications

Redirect URI should be
http://localhost
and be aware to grant all permissions.

