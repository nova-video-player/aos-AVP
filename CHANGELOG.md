# Nova Video Player changelog

## Important notes:
- migrating from v6 to v5 or below will delete all your scraping information

## v4.49.16 F-Droid only release - 9/1/2020
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1
- Attempt to fix F-Droid server build
- dav1d update to 0.8.1

## v6.00.04 Movie Collection experimental release - 7/1/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1
- Align with v5.16.16 with movie collections/sagas support on top
- WARNING: media db upgrade to version 38 (any downgrade will wipe out your meta data)

## v5.15.15 Google Play release - 7/1/2021
Testing branch: this release is based on minSDK 21, targetSDK 29, AndroidX libraries, NDK-r21, ffmpeg 4.3.1
- Align with v4.49.15 with latest jcifs-ng on top for SMBv2/3 support
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
