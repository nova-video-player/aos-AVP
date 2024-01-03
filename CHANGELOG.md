# Nova Video Player changelog

## v6.2.43 release 3/1/2024
- Handle properly gesture navigation screen layout in player UI

## v6.2.42 pre-release 1/1/2023
- Thinner player controller volume/seek bars
- Fix ftp not working due to time dependency
- Stability enhancements

## v6.2.41 pre-release 30/12/2023
- Faster local/USB storage scan at application start

## v6.2.40 release 22/12/2023
- Enforce new opensubtitles REST-API with quotas becoming mandatory in in January
- Disable gesture control when player screen is in locked mode
- New nova icon
- 2024 Android TV by year banners
- Attempt to support WebDAV 302 redirects
- Remember none subtitle track selection on resume
- Update boost to 1.84.0, libtorrent to 2.9.0
- Fix AV1 decoding regression
- Stability enhancements

## v6.2.38 release 27/11/2023
- Gesture stability enhancements

## v6.2.37 release 26/11/2023
- Add player gesture control
- Increase new opensubtitles REST-API downloader robustness

Following gestures are now supported:
- double tap on left/right regions of the screen for +-10s seek backward/forward
- scroll on left/right regions of the screen for brightness/volume increase/decrease

Two OSD regions have been added on top left/right screen part to display the fast rewind/forward icons and volume/brightness levels.

## v6.2.36 release 21/11/2023
- New nova icon
- opensubtitles subtitles download based on REST-API stability enhancements
- Update smbj to 0.13.0, ffmpeg to 6.1, dav1d to 1.3.0

Please report any multimedia regression with ffmpeg 6.1 (e.g. AV1 is broken right now).

## v6.2.35 release 14/11/2023
- Stability enhancements (crash on multi-selection subtitles download)
- Attempt to fix ftp on Android 7.1.2 devices cf. #829

## v6.2.34 release 12/11/2023
- New nova icon
- Add possibility to use new opensubtitles REST-API instead of XML-RPC that will be enforced in January
- Update jcifs-ng to 2.1.10, commons-net to 3.10.0, sshj to 0.37.0
- Add missing anime shows by alpha on Android TV
- Avoid top/bottom grey bars on chromebooks while playing videos

/!\ Please check new OpenSubtitles REST-API by activating it in nova settings and report any issue. OpenSubtitles will enforce use of this new API starting January 2024 and imposes download quotas (20 subs per day for a registered user, 5 otherwise). Note that you will need an opensubtitles.com account (and not an opensubtitles.org one)!

## v6.2.33 release 29/10/2023
- Fix F-Droid checkupdates bot release pickup

## v6.2.32 release xx/10/2023
- Update jcifs-ng to 2.1.10, commons-net to 3.10.0, sshj to 0.37.0

/!\ Please test if this release breaks ftp on firestick4k (not the max version) cf. https://github.com/nova-video-player/aos-AVP/issues/829

## v6.2.31 release xx/10/2023
- Fix hide subtitles by default not working regression
- Restore directories listed first when sorting by name

## v6.2.30 release 29/9/2023
- Final design to only disable SMB UDP discovery to cope with Fire 10 HD Wi-Fi issues

## v6.2.29 release candidate 24/9/2023
- Fix smbj not asking credentials when browsing an SMB server without guest account
- ffmpeg 4.4.4 upstep with DoVi patches
- dav1d 1.2.0 upstep
- openssl 1.1.1w upstep
- opus master upstep

## v6.2.28 release candidate 23/9/2023
- Add an option to limit SMB discovery to mDNS disabling TCP/UDP discovery that makes Wi-Fi drivers on some devices (e.g. Fire 10 HD) to crash and turn off Wi-Fi. Note that TCP/UDP discovery is required for proper ChromeOS SMB discovery.
- 
## v6.2.26 pre-release 21/9/2023
- Remove MANAGE_EXTERNAL_STORAGE permission since denied by Google Play (was allowed on Internal release but not Production ones...)
- Fix deactivate Dolby Vision setting 
- Audio speed when enabled can be incremented/decremented via CHANNEL UP/DOWN or NEXT/PREVIOUS TRACK MEDIA remote keys

## v6.2.25 release refused by Google 8/9/2023
- Fix DTS passthrough not working on some devices

NOTE: publication rejected by Google since nova is not allowed to use MANAGE_EXTERNAL_STORAGE though many other video player have managed to get it:
```
package: com.kmplayer
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
package: org.xbmc.kodi
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
package: com.mxtech.videoplayer.ad
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
package: video.player.videoplayer
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
package: com.kmp.video
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
package: com.mine.videoplayer
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
package: org.videolan.vlc
uses-permission: name='android.permission.MANAGE_EXTERNAL_STORAGE'
```
Result next release will not have this permission. I am not sure yet of collateral effects upgrading for those who installed this pre-release manually.

Message to Google:
> For good reasons Google restricts MANAGE_EXTERNAL_STORAGE permission since API31.
> Nova thus switched to MediaStore API.
> As a consequence nova is only able to see files registered as Media files by Google (missing video/subtitles formats such as ASS & NFO files).
> These files are not modifiable nor visible from nova when using local storage (incl. USB HDDs).
> This creates loss of functionality & incomprehension from nova users.
> Numerous appeals were issued & proper request filed for being granted the permission with explanation video.
> Only got default "no answers"/"not compliant" without having a Google support taking time to understand/review the case properly.
> Note that many other video players have the wanted MANAGE_EXTERNAL_STORAGE permission: e.g. VLC, mx player, video player all format, Video Player KMP, kodi...
> I consider this as unfair treatment and discrimination.
> Sad that an app that has almost 500k active users and 1.5M downloads on Google Play cannot get proper attention from Google.


## v6.2.24 pre-release 3/9/2023
- Enhanced network shortcut URI format check to avoid crashes when users inputs non valid entries

## v6.2.22 pre-release 1/9/2023
- Fix black screen playback on ONN and other Android TV 12 devices
- Fix capability test to read external storage regression due to MANAGE_EXTERNAL_STORAGE introduction


## v6.2.21 pre-release 29/8/2023
- Permission checker: fix crash seen with MANAGE_EXTERNAL_STORAGE permission on some Android versions
- Scrape enhancement: do not skip TV shows with no poster on TMDB in results when there is no other one proposed

## v6.2.20 pre-release 28/8/2023
- Support more scrape and subtitle languages
- Display audio/sub track titles
- Fix hdd subtitles download
- Many scrape enhancements (name cleanup removing brackets, solving long lasting bug on considering locale movie title, better show detection)
- This pre-release has MANAGE_EXTERNAL_STORAGE permission that seems to be allowed on Google Play finally for nova (TBC on full deployment): fixes issues not being able to process NFO/ASS and other files not considered as multimedia by Android library or not being owned by nova
- Integrate Slovak contributed translation
- Uprade smbj to 0.12.2 (fixes SMB faster implementation playback issues)
- Internationalization: all ISO639.(2(b)|3) 2/3 letter codes rely now on Android (still managing exceptions)
Subtitle "None" is listed as first item in subs selection
- Fix crash at start on devices with API<30 (Android 11)

## v6.2.17 release 23/6/2023
- Fix CI

## v6.2.16 release 22/6/2023
- Attempt to solve voice search on Android 11 (shieldTV)
- Do not crash if tmdb backend has outage
- Add m3u support in manifest (TBC if it works)

## v6.2.15 release 18/6/2023
- Fix A/V desync using playback speed
- Switched to jsch-mwiede fork for SFTP
- Use java 17

## v6.2.13 pre-release 26/5/2023
- smbj: fix subtitles download
- trakt: fix signing focus issue on Android TV

## v6.2.12 pre-release 25/5/2023
- smbj: increase robustness (fix timeout regressions, catch API errors)

## v6.2.11 pre-release 25/5/2023
- smbj: fix "empty folder issue" when connecting to network shortcut

## v6.2.10 pre-release 21/5/2023
- Add sort video option when browsing by folders
- Fix smbj folder delete
- Make smbj use bouncycastle security provider

## v6.2.8 pre-release 10/5/2023
- perfect smbj stability and SMB settings logic

## v6.2.7 pre-release 8/4/2023
- Add sshj new network shares support (alternate SFTP)
- Add an option to use smbj by default instead of jcifs-ng (not SMB1 compatible)
- Add an option to use sshj by default instead of legacy sftp support
- Webdav write support
- smbj and webdav stability improvements

## v6.2.5 really experimental pre-release 22/4/2023
/!\ Not for the faint of the heart: subject to crashes.

- smbj stability improvements (perhaps not yet stable)

## v6.2.4 really experimental pre-release 22/4/2023
/!\ Not for the faint of the heart: subject to crashes.

- smbj stability improvements (perhaps not yet stable)

## v6.2.3 really experimental pre-release 22/4/2023
/!\ Not for the faint of the heart: subject to crashes.

- smbj stability improvements (perhaps not yet stable)

## v6.2.2 really experimental pre-release 21/4/2023
/!\ Not for the faint of the heart: subject to crashes.

- Add smbj SMB2+ implementation capable of higher throughput than jcifs-ng (for now). smbj network shortcuts need to be added manually (no discovery in this release)
- Add webdav write support

## v6.1.6 github release 4/4/2023
- Add tx3g (mov_text) subtitles support

## v6.1.5 github release 31/3/2023
- Be sure to process year provided in movie files to increase scrape accuracy
- Fix regression in VideoLoaders

## v6.1.2 github release 20/3/2023
- Enhance webdav stabillity
- Fix all videos icon boxes not getting updated on AndroidTV
- Fix loss of video database content after exiting/re-entering the app on AndroidTV

## v6.1.1 github release 9/3/2023
- Add webdav network share support
- Add network shortcuts support for all network shares

## v6.0.97 release 12/2/2023
- Fix ftp regression on some firesticks
- Stability enhancements

## v6.0.96 release 8/2/2023
- Fix SMB1 regression on some NAS
- Perhaps fix F-droid not picking up new nova releases

## v6.0.95 Google Play release 8/2/2023
- More subtitles shades of grey
- Stability enhancements

## v6.0.94 release 4/2/2023
- Experimental playback speed option: fix subtitles not in sync and crash using bluetooth headsets
- Option to disable Dolby Vision decoder
- Pass list of subtitles to external video players

## v6.0.93 release 2/1/2023
- Stability enhancements
- External player compatibility: mark video as watched with Just Player upon video completion
- Attempt to rework internal storage import service to avoid non visible crash in background

## v6.0.89 release 10/12/2022
- Support more ssa subtitle style formats
- Fix SMB shortcut with empty user (guest) on AndroidTV
- 2023 banners for AndroidTV

## v6.0.88 release 29/11/2022
- Target API33
- boost/libtorrent 1.80.0/2.0.8 upstep
- jcifs-ng SMB upstep to latest master
- Bundle delivery to Google Play
- Stability enhancements

## v6.0.87 release 21/11/2022
- Fix infinite loop in refreshrate negotiation
- Stability enhancements


## v6.0.83 release 13/11/2022
- Increase number of subtitles track supported to 64
- Stability enhancements


## v6.0.82 release 12/11/2022
- Experimental playback speed option is back but disabled by default (could cause choppy video)
- Better movie scrape results through applying Levenshtein distance on tmdb scrape results
- Hidden advanced option to enable specifying lavc parser sync mode (PTS or sample)

## v6.0.81 Google Play release 8/11/2022
- Re-disable experimental playback speed control due to instabilities

## v6.0.80 Google Play release 5/11/2022
- Fix db update crash

## v6.0.79 Google Play release 5/11/2022
- Crowdin translations synchronization
- Stability enhancements

## v6.0.78 pre-release 4/11/2022
- Add option to not apply audio passthrough if AV receiver does not support codec
- Fix external storage videos perceived as not indexed on Android TV boxes

## v6.0.77 pre-release 28/10/2022
- Re-enable experimental playback speed control but avoid to enforce change of speed if 1.0x is selected
- Fix network share videos staying in movie collection after deletion

## v6.0.76 Google Play release 26/10/2022
- Disable experimental playback speed control for now since causes regressions

## v6.0.75 Google Play release 23/10/2022
- Experimental playback speed control stability improvements (only when not using audio passthrough)
- Stability enhancements

## v6.0.74 pre-release 16/10/2022
- Target Android API32
- Experimental playback speed control
- Do not apply audio passthrough if receiver does not support codec use and revert to PCM multichannel decoding instead
- Fix some local video files not indexed on recent Android
- ffmpeg 4.4.3, openssl 1.1.1r, androidx library updates
- Stability enhancements

## v6.0.71 release 23/6/2022
- Stability enhancements

## v6.0.70 release 21/6/2022
- Play button is first on tvshow all episodes view on ADTV
- Remove duplicate downmixing setting on phone/tablet UI
- Fix cannot play SMB file resulting from search result
- Stability enhancements

## v6.0.68 pre-release (SMB experimental) 12/6/2022
- enable SMBv3
- add possibility to browse/add SMB network share manually by URI on Android TV
- 2022 year movie banner on Android TV

## v6.0.67 release 5/6/2022
- Fix youtube trailers not opening on youtube app on Android TV
- Add traditional Chinese, Brazilian, Ukrainian, Kurdish scrape/subs support
- Fix trakt multi-devices last played synchronization
- jcifs-ng SMB upstep
- Stability enhancements

## v6.0.66 release 15/5/2022
- Add possibility to exclude network shortcuts from automatic/scheduled/manual global rescans on Android TV
- Optimize launch time on Android TV
- Stability enhancements

## v6.0.65 release 8/5/2022
- Make animation row optional on android TV
- Add more blacklisted local storage directories to speed up media import
- Stability enhancements

## v6.0.64 release 3/5/2022
- Stability enhancements
- New address for Sentry debug backend integration (crashlytics)

## v6.0.63 amazon release 24/4/2022
- Stability enhancements
- Fix adaptive refresh rate selection on firestick
- ffmpeg 4.4.2 and dav1d 1.0.0
- Fix fdroid build

## v6.0.62 amazon release 18/4/2022
- Stability enhancements
- revert to ffmpeg 4.4.1 due to regression reported

## v6.0.61 pre-release 14/4/2022
- Stability enhancements
- ffmpeg 5.0.1, dav1d 1.0.0, opus latest master upsteps (please report any **regression** on multimedia playback) 

## v6.0.58 pre-release 4/4/2022
- Stability enhancements
- Sentry debug backend integration for crashlytics

## v6.0.55 pre-release 27/3/2022
- Display content rating and better audio/resolution tag on leanback

## v6.0.52 pre-release 11/3/2022
- Fix fdroid build

## v6.0.51 pre-release 11/3/2022
- Fix crash happening during scrape
- Stability enhancements
- 
## v6.0.50 pre-release 8/3/2022
- Fix tvshow rescrape having same name
- Stability enhancements

## v6.0.49 pre-release 6/3/2022
- Decrease UI glitch on browse by TV show on phone UI
- Stability enhancements

## v6.0.48 pre-release 4/3/2022
- Fix widget not launching video
- STOP remote button stops player
- Make rescan storage setting work
- Stability enhancements


## v6.0.47 pre-release 1/3/2022
- Scrobbler threshold raised to 90%
- Fix crash changing info on tvshow
- Add adult scrape hidden option NOT on google play
- Blacklist nova scrape files for initial video import
- Swedish translations
- Fix NFO processing not working on SMB share
- Fix scrape in loop

## v6.0.46 pre-release 18/2/2022
- Writer tag for tvshow retrieved on tmdb
- Scraper enhancements
- No more next episode jumping button on TV UI back from played video
- Translations: Swedish and Traditional Chinese progress
- Speed up initial local storage video import blacklisting whatsapp files before import
- WARNING: media db upgrade (any downgrade will wipe out your meta data)

## v6.0.43 pre-release 3/2/2022
- Add https streaming support
- Fix wrong application name

## v6.0.41 pre-release 1/2/2022
- Truly (?!) eliminate sponsor link causing application rejection. Link was only visible for sideloaded apk but not for GooglePlay installation. Google refuses to check this point.
- Traditional Chinese translations

## v6.0.40 internal release 1/2/2022

- Eliminate sponsor link causing application rejection. Link was only visible for sideloaded apk but not for GooglePlay installation. Google refuses to check this point.
- Remove application name translation. Google test translates Czech and Portuguese "nova video player" back to English to "new video player" causing rejection. Other applications like "nova launcher" do not face such issue.
- Reformat trakt login dialog to keep track of watched videos: it causes rejection without reason provided

## v6.0.37 pre-release 14/1/2022
- Make sponsor link enabled as compilation option.

## v6.0.36  Google play internal (non public) release 23/12/2021
- Movie collections/sagas support on Android TV
- Separate animation/movies/series sections on Android TV
- Faster TV shows media information retrieval
- Report properly DTSHD & DTSHD MA
- ffmpeg 4.4.1 & dav1d 0.9.2 upstep
- MDNS samba discovery
- New refresh rate selection algorithm optimizing judder effect
- Add domain option to samba network credential dialog
- Optimize network shares rescan speed when files deleted/renamed
- Dolby vision support
- Binge watch mode
- Fix trakt tvshow sync
- Target API31 (warning: relocation of nfo/jpg for local storage videos)
- WARNING: media db upgrade (any downgrade will wipe out your meta data)

## v5.15.21 Google Play release - 1/9/2021
This release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r22, ffmpeg 4.4

- Fix crash on Android 12/S/API31
- Full screen display is enabled by default even on displays with cutouts
- Properly report DTS-HD and DTS-HD MA
- ffmpeg 4.4 and dav1d 0.9.2 integration
- Better tv show subtitle download based on IMDB ID
- Disable delete on UPnP shares not supporting it

## v6.00.34 Google Play internal release (non public) - 30/12/2021
This release is based on minSDK 21, targetSDK 31, AndroidX libraries, NDK-r22, ffmpeg 4.4.1

- Movie collections/sagas support on Android TV
- Separate animation/movies/series sections on Android TV
- Faster TV shows media information retrieval
- Report properly DTSHD & DTSHD MA
- ffmpeg 4.4.1 & dav1d 0.9.2 upstep
- MDNS samba discovery
- New refresh rate selection algorithm optimizing judder effect
- Add domain option to samba network credential dialog
- Optimize network shares rescan speed when files deleted/renamed
- Dolby vision support
- Binge watch mode
- Target API31 (warning: relocation of nfo/jpg for local storage videos)
- Fix trakt sync for tvshows
- WARNING: media db upgrade (any downgrade will wipe out your meta data)

**Important migration notes:**

* This new version upgrades the internal nova media database to a new scheme and any downgrade to v4/v5 versions of nova will wipe out
 your entire video collection to prevent any incompatibility.
* This version switches to theMovieDb for retrieving TV shows information instead of theTvDb. It is strongly recommended to rescrape all your TV shows or start from a fresh install.
* Proper support for movie collections and animation movies/series on AndroidTV requires some manual steps. Acquisition of the additional movie collection informations and movies/TV series genres realignment requires a
 full rescrape of your video without interference of existing .nfo files (that do not yet contain the required information). For that purpose the following steps should do the trick:
    * backup all your customized handcrafted .nfo file (if you have any)
    * install nova version 6.xx
    * in nova settings unselect "process '.nfo' files"
    * in nova settings launch a "rescrape all" and wait for completion
    * in nova settings launch an "export already scraped videos" and wait for completion (**this step will override any existing .nfo file**)
* versions later than v6.0.30 targets API31 and due to Android storage restrictions for API30, local NFO/JPG media information files for videos stored on local storage have been moved to nova public application folder located /sdcard/Android/data/org.courville.nova/files/nfoPoster 
 * If you ever want to get back to nova v5.xx, you will need to clean application data *and cache*

## v7.00.01 ExoPlayer experimental release - xx/xx/2021
Testing branch: this release is based on minSDK 21, targetSDK 30, AndroidX libraries, NDK-r22, ffmpeg 4.3.1
- Add ExoPlayer with ffmpeg video support as alternate player (hidden for now)

## v5.15.20 Google Play release - 9/5/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r22, ffmpeg 4.3.2
- Better tv show subtitle download based on IMDB ID
- Disable delete on UPnP shares not supporting it

## v5.15.19 Google Play release - 19/3/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r22, ffmpeg 4.3.2

- Fix occasional SMB2/3 timeouts
- Add support for coloured TV remote buttons via HDMI-CEC
- ffmpeg version 4.3.2 and dav1d version 0.8.2 upstep

## v4.49.17 F-Droid only release - 16/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r22, ffmpeg 4.3.1

- Yet another attempt to fix F-Droid server build
- NDK r22 support

## v6.00.05 Movie Collection experimental release - 22/1/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r22, ffmpeg 4.3.1

- Align with v5.16.18 with movie collections/sagas support on top
- WARNING: media db upgrade to version 38 (any downgrade will wipe out your meta data)

## v5.15.18 Google Play release - 22/1/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r22, ffmpeg 4.3.1

- Latest jcifs-ng on top for SMBv2/3 support
- Use DNS,BCAST default SMB resolver order to avoid slow SMB share responses in some network configurations
- Allow AV1 hardware decoding
- Switch to NDK r22

## v6.00.04 Movie Collection experimental release - 7/1/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v5.16.16 with movie collections/sagas support on top
- WARNING: media db upgrade to version 38 (any downgrade will wipe out your meta data)

## v5.15.16 Google Play release - 7/1/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.16 with latest jcifs-ng on top for SMBv2/3 support
- Fix non systematic wrong IP selected when browsing SMB shares
- New debug infrastructure based on slf4j/logback
- New 2021 banner icons for AndroidTV
- dav1d update to 0.8.1

## v4.49.15 Google Play release - 8/12/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- SMB1 support only rollback release aligned with v5.15.14 without jcifs-ng support to address SMB issue seen in the field

## v6.00.03 experimental release - 4/12/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v5.15.13 with movie collection/saga support

## v5.15.14 Google Play release - 6/12/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.11 with latest jcifs-ng on top
- Attempt to fix SMB on WD Mycloud with guest login

## v5.15.13 Google Play release - 4/12/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.11 with latest jcifs-ng on top
- Fix SMB timeout happening on some servers (jcifs-ng resolver)

## v4.49.11 Google Play release - 3/12/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Rollback release aligned with v5.15.11 without jcifs-ng support to address SMB issue seen in the field https://github.com/nova-video-player/aos-AVP/issues/398

## v6.00.01 experimental release - 28/11/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Add movie collection/saga support
- Clearer watched mark on movie/show/collection view

## v5.15.11 Google Play release - 28/11/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- SMBv2/3 support via jcifs-ng
- Fix anime playback using opus track using libopus instead of platform one
- Update trakt/tmdb/thetvdb-java libraries to 6.8.5/2.2.0/2.4.0
- Restrict nova webview to nova usage
- Stability enhancements

## v5.15.10 SMBv2/3 not so experimental release anymore - 23/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.11 with latest jcifs-ng on top

## v4.49.11 Google Play release - 23/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Stability enhancements

## v5.15.9 SMBv2/3 not so experimental release anymore - 20/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.10 with latest jcifs-ng on top

## v4.49.10 Google Play release - 20/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Fix folder play mode
- Correct subtitles download failing while playing video on local storage

## v5.15.8 SMBv2/3 not so experimental release anymore - 13/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.9 with latest jcifs-ng on top

## v4.49.9 Google Play release - 13/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Fix time displayed at video start on Android TV regression

## v5.15.7 SMBv2/3 not so experimental release anymore - 11/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.8 with latest jcifs-ng on top

## v4.49.8 Google Play release - 11/10/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Do not stop local video playback on network connectivity change
- Use new nova icon for search bar
- Fix search crash on old Amazon firesticks
- Fix wrong player layout when screen rotation is locked and video started in portrait

## v5.15.6 SMBv2/3 not so experimental release anymore - 25/9/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.7 with latest jcifs-ng on top
- Fix guest login on win10

## v5.15.5 SMBv2/3 not so experimental release anymore - 17/9/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Align with v4.49.7 with latest jcifs-ng on top

## v4.49.7 Google Play release - 17/9/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1

- Display external storage label/description on AndroidTV
- Do not pollute subtitle manual picker with cached online retrieved subs
- Allow http video streaming
- chromeOS/Amazon UI fixes
- Add missing subtitles ISO639 code strings
- ffmpeg version 4.3.1 and dav1d version 0.7.1 upstep
- Stability enhancement

## v5.15.4 SMBv2/3 not so experimental release anymore - 31/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3

- Align with v4.49.6 with latest jcifs-ng on top

## v4.49.6 Google Play release - 31/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3
- Fix video stopping often on arm64 due to latest ffmpeg upstep
- Revert to ffmpeg 4.3.2 and dav1d 0.7.0

## v5.15.3 SMBv2/3 not so experimental release anymore - 18/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.0

- Align with v4.49.5 with latest jcifs-ng on top
- Attempt to fix SMB win10 guest support

## v5.15.2 SMBv2/3 not so experimental release anymore - 11/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.0

- Align with v4.49.5 with latest jcifs-ng on top

## v4.49.5 Google Play release - 11/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.0

- Fix x86 software decoding support (nexus player, non 64b chromebooks)
- Faster network scanning
- Stability enhancement

## v5.15.1 SMBv2/3 not so experimental release anymore - 8/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.0

- Align with v4.49.3 with latest jcifs-ng on top
- Fix samba issues reported with WD MyCloud and with win10 guest login

## v4.49.3 Google Play release - 7/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.0

- Better USB disk detection and management on AndroidTV
- Stability enhancement

## v4.49.2 Google Play release - 6/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3
- Fix OOM on Android TV with HDD plugged

## v4.49.1 Google Play release - 4/7/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3

- Fix number of audio tracks limited to 6
- ffmpeg version 4.3.0 and dav1d version 0.7.1 upstep
- Stability enhancement

## v4.48.18 release - 28/6/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3

- Add sponsor link when not installed from Google Play
- Reduce compilation strain on boost
- Stability enhancement

## v4.48.10 release - 20/6/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3

- Stability enhancement

## v4.48.9 release - 11/6/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3

- Fix missing poster on some movies
- Fix playback not smooth regression on Sony and Philips AndroidTV
- Stretch mode is back
- Allow adaptive refresh rate on phones
- Improve A/V sync for some videos (PTS instead of sample based sync)
- Scraping improvements
- Stability enhancement

## v4.48.8 release - 30/5/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.2.3

- solve some A/V sync issues
- 0.7.0 dav1d and ffmpeg 4.2.3 upsteps
- faster boost compilation

## v4.48.6 release - 13/5/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Upgrade jsch for sftp support
- upgrade cling for UPnP support
- Stability enhancements

## v5.14.8 SMBv2/3 Google Play beta release - 12/5/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Fix SMB server protocol level detection scheme
- Stability enhancements

## v5.14.7 SMBv2/3 Google Play beta release - 10/5/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Experimental SMBv2/3 support with latest jcifs-ng
- Support for SMBv2 is disabled by default and can be enabled in settings
- Disable SMB1/SMB2 protocol negotiation when SMB2 server is detected
- jsch update for sftp
- Stability enhancements

## v4.48.4 Google Play release - 10/5/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.48.3 with these changes:

- Stability enhancements

## v5.14.5 SMBv2/3 Google Play beta release - 9/5/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.48.3 with latest jcifs-ng on top for SMBv2/3 support
- Support for SMBv2 is disabled by default and can be enabled in settings

## v4.48.3 Google Play release - 8/5/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.48.2 with these changes:

- Revert back jsch upstep since maven version without custom changes is too slow
- Stability enhancements

## v5.14.4 SMBv2/3 experimental release - 8/5/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.48.2 with latest jcifs-ng on top
- Support for SMBv2 is disabled by default and can be enabled in settings

## v4.48.2 Google Play beta release - 3/5/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.48 with these changes:

- Fix ability to open videos via http/https from another application
- Improved scraping results
- UI navbar correct color on Samsung
- jsch update for sftp
- Stability enhancements

## v5.13 SMBv2/3 experimental release - 13/4/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.48 with latest jcifs-ng on top
- Fix slow video start on SMB by avoid checking .nomedia on server root

## v4.48 Google Play beta release - 18/4/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.47 with these changes:

- Improve scraping results
- Stability enhancements

## v5.12 SMBv2/3 experimental release - 13/4/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.47 with latest jcifs-ng on top
- Fix samba file listing truncation when dealing with SMBv1 only servers
- Add opensubtitles credentials support in preferences since opensubtitles mandates it to download subtitles
- Fix an appcompat incompatibility with webview (Google bug)

Note that this release will experience interoperability issues when using SMBv1 only capable server.

## v4.47 Google Play beta release - 11/4/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.46 with these changes:

- Fix trakt resume point sync issues

## v4.46 Google Play beta release - 5/4/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.44 with these changes:

- Fix opensubtitles change requiring credentials to use API
- Fix DTSHD playback crashing sometimes

## v4.44 Google Play release - 5/4/2020
Stable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.39 with these changes:

- Fix opensubtitles change requiring credentials to use API
- Fix DTSHD playback crashing sometimes

## v4.43 beta release - 31/3/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.40 with these changes:

- Subtitle manual download improvement via scraped information search
- UI polishing on phones/tablets and partners logo refresh (trakt, tmdb, tvdb, imdb)
- AppCompat migration

## v5.10 SMBv2/3 experimental release - 2/3/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.40 with latest jcifs-ng on top

Note that this release will experience interoperability issues when using SMBv1 only capable server.

## v4.40 Google Play beta release - 2/3/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

Based on v4.38 with these changes:

- Refactored TmDb and TheTVDb scrapers
- Better TV show scrape result through multi-language Levenshtein metric computation
- Fix crash observed on play console
- Use new application icon for TV channels

## v4.39 Google Play release - 2/3/2020
Stable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Fix crash observed on play console
- Use new application icon for TV channels

## v5.9 SMBv2/3 experimental release - 1/3/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.38 with latest jcifs-ng on top

## v4.38 Google Play beta release - 29/2/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Refactored TmDb and TheTVDb scrapers
- Better TV show scrape result through multi-language Levenshtein metric computation
- Fix cloud storage (file picker) and folder picker on phones

## v4.37 Google Play release - 29/2/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Fix cloud storage (file picker) and folder picker on phones

## v4.36 release - 22/2/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Roll back to old MovieScraper2
- 10ms audio/video delay tuning 
- Latest translations

## v4.35 release - 8/2/2020
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.2
- Switch to tmdb-java movie scraper
- Use new mode based switch API instead of refresh rate based one for adaptive refresh rate (fixes FireTV4k)
- Switch to app bundles to reduce apk size

## v4.28.3 release - 8/2/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix TV show Trakt progress sync
- Fix grey bar issue on Sony when watching HDR content
- Fix green bars present in software decoding on Nvidia shield
- Fix audio regressions in night/boost mode
- Fix video not opening when enabling adaptive refresh rate on FireTV

## v5.8 release - 24/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Align with v4.33 with jcifs-ng on top

## v4.33 release - 24/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Fix regression in TV show not recognized due to TheTVdb backend unilateral change

## v4.31 release - 24/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.2

- Fix indexing counter looping due to thetvdb site changes

## v4.28.2 Google Play release - 24/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix regression in TV show not recognized due to TheTVdb backend unilateral change

## v4.28.1 Google Play release - 24/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix indexing counter looping due to thetvdb site changes
- Fix build with latest NDK

## v4.30 Google Play beta release - 22/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Use Audiotrack instead of OpenSL ES for audio interface improving video fluidity
- Fix TV show Trakt progress sync
- Disable periodic bookmark save that could interfere with video decoding performance over contrained bandwidth network shares
- Complete Turkish and Simplified Chinese translations
- New icon compliant with Google Play Store requirements
- Only launch SMB discovery on local networks
- New hidden force audio interface setting for experimentation
- Fix indexing counter looping due to thetvdb site changes

## v4.29 Google Play beta release - 11/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix HEVC 10 bit support on Rockchip devices 
- Better extradata management for AVC and HEVC for MediaCodec
- Stability enhancements

## v4.28 Google Play release - 11/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Prefer ffmpeg over c2.android or omx.google software codecs to avoid multimedia issues on pixel3xl phone
- Stability enhancements

## v4.27 Google Play beta release - 5/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- ffmpeg update to 4.2.2
- dav1d update to 0.5.2
- Break video import and scrapie in small queries to avoid database window cursor issues
- Stability enhancement

## v4.26 Google Play release - 29/12/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Better scrape result through Levenshtein result distance computation
- Stability enhancement

## v4.25 Google Play release - 26/12/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Introduce stretched video format to fill entire display with video image (only way to preserve aspect ratio on recent Philips TVs!)
- Add Norwegian, Vietnamese scrape languages support
- 2020 year banners for Android TV
- Improve filename pre-processing garbage rules to improve scrape
- Prevent scrape notification to fire up when nothing is to be scraped
- Fix sftp indexing

## v5.7 SMBv2 beta release - 14/12/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Align with v4.24 with jcifs-ng on top

## v4.24 Google Play release - 14/12/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix more shows not being scraped correctly after thetvdb.com site changes
- Rollback on jcsh upgrade yielding issues on sftp
- Fix regression in pause/play with enter key on AndroidTV
- Fix some aspect ratio issues on devices where MediaCodec returns wrong video dimensions (firetv4k, rockchip, etc.)
- Reduce bottom player UI glitch on chromebook and rockchip leanback interfaces

## v4.22 Google Play release - 8/12/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix some shows not being scraped correctly after thetvdb.com site changes
- Fix player controller UI layout issues on tablets
- update thetvdb-java to version 2.2.0

## v4.21 Google Play release - 7/12/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Faster AndroidTV display entering application
- Attempt to fix an UI glitch on Rockchip based TV boxes
- Stability enhancements

## v5.6 SMBv2 beta release - 1/12/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix SMBv1 guest/anonymous auth on freebox

## v4.20 Google Play release - 1/12/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Stability enhancements

## v4.18 Google Play release - 22/11/2019
Testing branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix player crashing in Dutch due to translation error
- Fix TV shows meta data retrieval issues due to to TheTVdb.com backend changes

## v4.17 Google Play release - 18/11/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Stability enhancements

## v4.16 Google Play release - 17/11/2019
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Migration to TheTVDB API v2 via thetvdb-java external library with request caching support
- Target API29 disabling scoped storage for now
- Indexing, scraping and file copy proper foreground notifications
- Stability enhancements

## v5.5 Google Play beta release - 6/11/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix lack of focus on last added video row at application start on leanback

## v5.4 Google Play beta release - 4/11/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix cursor based fragments lack of refresh after video deletion on phones/tablets

## v5.3 Google Play beta release - 3/11/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Leanback setting style for subtitles languages download
- Remove systematic video background reload in VideoDetailsFragment on leadback when back from video play
- Stability enhancements

## v5.2 Google Play beta release - 27/10/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix selection of torrent streaming download directory not selectable
- Indexing, scraping and file copy proper foreground notifications
- Stability enhancements

## v5.1 unstable branch release - 21/9/2019
Unstable branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Switch to jcifs-ng to support SMBv2/3
- Target API29 (Android Q) and disable scoped storage for now

## v4.15 Google Play release - 16/9/2019
Testing branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Fix resume point update on VideoInfoActivity and auto scraping of unknown files on network shares

## v4.14 Google Play beta release - 15/9/2019
"Not so much anymore unstable branch": this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2.1

- Only switch to AudioTrack instead of openSLES to solve audio/video delay on Amlogic
- Upgrade to latest version of trakt-java containing NVP upstreamed contribution
- Add support for codepade 28606 - Latin-10 or South-Eastern European for subs

## v4.13 Google Play beta release - 8/9/2019
"Not so much anymore unstable branch": this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- Switch to AudioTrack instead of openSLES to solve audio/video delay on most devices
- Disable for now UpNext row/channel preventing display of indexed folders
- Upgrade trakt-java library to solve two ways sync

## v4.12 Google Play beta release - 29/8/2019
"Not so much anymore unstable branch": this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- Fix HEVC decoding for some files on MTK based devices
- Do not revert on SW decoding in presence of high bitrate spike occurring on some 4k high bitrate videos

## v4.11 Google Play beta release - 28/8/2019
"Not so much anymore unstable branch": this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- Fix coexistence with Archos Video Player

## v4.10 Google Play beta release - 22/8/2019
"Not so much anymore unstable branch": this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- Fix video blacklisting on local storage

## v4.9 unstable branch release - 21/8/2019
"Not so much anymore unstable branch": this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- FFmpeg upstep to 4.2 and dav1d to 0.4.0
- Fix database crash preventing application to start on some custom ROMs

## v4.8 unstable branch release - 2/8/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- Fix database crash preventing application to start on some devices

## v4.7 unstable branch release - 15/6/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r20, ffmpeg 4.2

- Improve audio passthrough robustness
- Fix authentication issue with Trakt

## v3.11 Google Play beta release - 15/6/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r20, ffmpeg 4.2

- Improve audio passthrough robustness

## v3.10 Google Play release - 9/6/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19c, ffmpeg 4.2

- Fix authentication issue with Trakt

## v4.6 unstable branch release - 3/6/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r19c, ffmpeg 4.2

- Attempt to fix UPnP playback of files containing a "/"
- Do not crash when opening non-video files in browser
- Stability improvements

## v3.9 Google Play beta release - 1/6/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19c, ffmpeg 4.2

- Attempt to fix UPnP playback of files containing a "/"
- Do not crash when opening non-video files in browser
- Stability improvements

## v4.5 unstable branch release - 30/5/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r19c, ffmpeg 4.2

- Fix files cannot play from external sdcard using an external player
- AndroidTV: fix EpisodesByDate week view crash in case of large TV show collection

## v3.8 Google Play release - 30/5/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19c, ffmpeg 4.2

- Fix files cannot play from external sdcard using an external player

## v4.3 unstable branch release - 19/5/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r19c, ffmpeg 4.2

- Scanning and scraping proper Notifications
- Add an option to force disabling stereo downmix on phones/tablets with Android version > N
- AndroidTV: add pinning on long press for all movies/tvshows
- New TV show categories for quicker browsing through large collection
- Countless TV UI improvements (roles, trailers, badges, global del/deindex, subs picker)
- New player shortcuts (A/S switch audio/sub track, U/D = volume up/down) and menu support
- Improve audio passthrough stability
- Fix sftp playback interruptions
- Make private mode persistent
- Fix cloud support (still no streaming)- AndroidTV: add poster/backdrop zoom on long press
- AndroidTV: add tvshow episodes by date view
- Fix sftp playback interruptions
- Fix an android Q DP3 crash

## v2.2 stable branch release - 19/5/2019
Stable branch: this release is based on minSDK 17, targetSDK 27, NDK-r16b, ffmpeg 3.3.x.

- New TV show categories for quicker browsing through large collection
- Countless TV UI improvements (roles, trailers, badges, global del/deindex, subs picker)
- New player shortcuts (A/S switch audio/sub track, U/D = volume up/down) and menu support
- Improve audio passthrough stability
- Fix sftp playback interruptions
- Make private mode persistent
- Fix cloud support (still no streaming)
- Fix an android Q DP3 crash

## v3.7 Google Play release - 24/5/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19c, ffmpeg 4.2

- Fix software decoding fallback in case of error
- Re-enable downmix on phones to avoid voice channels loss on some phones
- Stability improvements
- Upgrade to latest ffmpeg and dav1d soft codecs
- Fix an android Q DP3 crash

## v4.2 API28+AndroidX beta release - 27/4/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r19c, ffmpeg 4.2

- Option to have landscape fullscreen video on display with cutouts
- AndroidX migration
- Poster/backdrop zoom on AndroidTV via long press
- Improve stability of phone/tablet UI after API28 migration
- New A-Z orb option in All TV shows/Movies for alphabetical order browsing
- New all/not viewed orb option in All TV shows/Movies for limiting browsing to all/not viewed videos

## v3.6 Google Play beta release - 27/4/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19, ffmpeg 4.2

- Upgrade to latest ffmpeg and dav1d soft codecs

## v3.5 release candidate - 17/4/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19, ffmpeg 4.2

- Fix software decoding on pre-M Android versions

## v4.1 API28 beta release - 8/4/2019
Unstable branch: this release is based on minSDK 21, targetSDK 28, AndroidX libraries, NDK-r19, ffmpeg 4.2

- New video overview
- Leanback style settings on AndroidTV
- Add recently added TV channels
- Improved subtitles picker wizard look
- API28 migration

## v3.3.1 Google Play beta release - 11/3/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19, ffmpeg 4.2

- New TV show categories on TV interface for quicker browsing through large collection
- Countless TV UI improvements (player look and feel, roles, movies trailers, audio badges, global deleletion/de-indexation, subtitles picker, more dynamic banners)
- New player shortcuts (A/S switch audio/sub track, U/D = volume up/down) and menu support
- Improve audio passthrough stability
- Fix crash in presence of damaged sdcard
- Fix cloud support (still no streaming)
- Do not downmix to stereo on phones/tablets if Android is recent enough (N): delegate to Android

## v3.4 special SMBv2/3 test release (experimental) - 18/3/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19, ffmpeg 4.2

- SMBv2/3 support via jcifs-ng
- Ability to deindex local folders

## v3.1 Google Play beta release 3/2/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19, ffmpeg 4.2

- New TV show categories on TV interface for quicker browsing through large collection

## v3.0 Google Play beta release - 30/1/2019
Testing branch: this release is based on minSDK 21, targetSDK 27, NDK-r19, ffmpeg 4.2

- Migration from Android ndk-r17 to ndk-r19
- Add AV1 soft decoding capability through 4.2-dev ffmpeg version and dav1d codec
- Add support for x86_64 architecture
- Improve audio passthrough stability
- Make private mode persistent between application relaunches

## v2.1 Google Play public release - 20/9/2018
Stable branch: this release is based on minSDK 17, targetSDK 27, NDK-r16b, ffmpeg 3.3.x.

- Improved french translations and interfacing with crowdin service
- Stability improvements

## v2.0 Google Play public release - 7/9/2018
Stable branch: this release is based on minSDK 17, targetSDK 27, NDK-r16b, ffmpeg 3.3.x.

- Scraper improvements and bug fixes
- Issue a warning toast is hardware decoding is disabled

## v1.0 Initial Google Play public release - 26/8/2018
Compared to Archos Video Player open source release, following changes were made:

- Add support for Android P avoiding application crash at startup
- Add a "list episodes" button on tvshow episode view to quickly get to tvshow view on AndroidTV leanback version
- Add notification channels for Oreo
- Fix subtitle delay not applied on play resume when negative
- Fix floating player crash on Android version Oreo and above
- Fix loss of activity background and private mode background
- Prevent from playing a file when detecting a problem: issue a toast instead
