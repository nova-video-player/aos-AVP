# Nova Video Player changelog

## v4.x current git
- Scanning and scraping proper Notifications
- Add an option to force disabling stereo downmix on phones/tablets with Android version > N
- AndroidTV: add pinning on long press for all movies/tvshows
- AndroidTV: add poster/backdrop zoom on long press
- AndroidTV: add tvshow episodes by date view

## v3.7 Google Play public release - 11/5/2019
- Fix crashes related to new external storage management
- Re-enable downmix on phones to avoid voice channels loss on some phones
- Stability improvements

## v4.2 API28+AndroidX beta release - 27/4/2019
- Option to have landscape fullscreen video on display with cutouts
- AndroidX migration
- Poster/backdrop zoom on AndroidTV via long press
- Improve stability of phone/tablet UI after API28 migration
- New A-Z orb option in All TV shows/Movies for alphabetical order browsing
- New all/not viewed orb option in All TV shows/Movies for limiting browsing to all/not viewed videos

## v3.6 Google Play beta release - 27/4/2019
- Upgrade to latest ffmpeg and dav1d soft codecs

## v3.5 release candidate - 17/4/2019
- Fix software decoding on pre-M Android versions

## v4.1 API28 beta release - 8/4/2019
- New video overview
- Leanback style settings on AndroidTV
- Add recently added TV channels
- Improved subtitles picker wizard look
- API28 migration

## v3.3.1 Google Play beta release - 11/3/2019
- New TV show categories on TV interface for quicker browsing through large collection
- Countless TV UI improvements (player look and feel, roles, movies trailers, audio badges, global deleletion/de-indexation, subtitles picker, more dynamic banners)
- New player shortcuts (A/S switch audio/sub track, U/D = volume up/down) and menu support
- Improve audio passthrough stability
- Fix crash in presence of damaged sdcard
- Fix cloud support (still no streaming)
- Do not downmix to stereo on phones/tablets if Android is recent enough (N): delegate to Android

## v3.4 special SMBv2/3 test release (experimental) - 18/3/2019
- SMBv2/3 support via jcifs-ng
- Ability to deindex local folders

## v3.1 Google Play beta release 3/2/2019
- New TV show categories on TV interface for quicker browsing through large collection

## v3.0 Google Play beta release - 30/1/2019
- Migration from Android ndk-r17 to ndk-r19
- Add AV1 soft decoding capability through 4.2-dev ffmpeg version and dav1d codec
- Add support for x86_64 architecture
- Improve audio passthrough stability
- Make private mode persistent between application relaunches

## v2.1 Google Play public release - 20/9/2018
- Improved french translations and interfacing with crowdin service
- Stability improvements

## v2.0 Google Play public release - 7/9/2018
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
