## What is Nova Video Player?

NOVA is an opeN sOurce Video plAyer designed for Android devices (tablets, phones and TVs).  
This application is based on a fork of Archos Video Player open-source release, intended to support new features with an enhanced stability.

NOVA is published on [GooglePlay](https://play.google.com/store/apps/details?id=org.courville.nova) or on [Amazon Appstore](https://www.amazon.fr/dp/B07P1Q1DG9) or on [Huawei AppGallery](https://appgallery.huawei.com/#/app/C102811509) or on [F-Droid](https://f-droid.org/en/packages/org.courville.nova/) or directly on [github](https://github.com/nova-video-player/aos-AVP/releases). 
Latest changes are tracked [here](https://github.com/nova-video-player/aos-AVP/blob/nova/CHANGELOG.md).

Please note that NOVA is free and consists in a small community effort done on personal time.

## I have just downloaded Nova Video Player and it shows no video.

On a fresh start, the discovery process for videos stored on local storage can take some time.  
Nova Video Player is just a video player and does not point to any streaming service. If you do not have already video content on your device no videos will be displayed.

Network shares can also be added as video sources.

## What is the difference between passthrough mode 1 and passthrough mode 2?

Audio passthrough amounts to transmit through HDMI interface compressed sound channels directly to your AV receiver that will perform the decoding and rendering. It is thus a feature targeted for Android TV or TV boxes.  
On Nova Video Player, two experimental audio passthrough modes are supported:  

* Mode 1 targets TV boxes with early versions of Android (up to Kitkat 4.4). Note that on some devices you need to set the sound volume to maximum (so that the streams are not altered by the sound mixer).
* Mode 2 targets latest versions of Android above 5.1 (Nvidia Shield TV and télévision Android TV).

You might have to try the two modes and figure out what suits you best depending on the multi-channel audio codec used in your video files.

Note that:

* when using an Android TV box (not an Android TV TV) directly connected via HDMI to your AV multichannel receiver and thus not through ARC, multichannel support can be achieved through multichannel PCM which is natively supported by Nova without the need to activate passthrough;
* multichannel PCM or AAC is not supported via ARC (eARC is required) resulting in stereo output

More details are available [here](https://github.com/nova-video-player/aos-AVP/wiki/Audio-and-passthrough).

## Some videos play really slowly on my device.

Nova Video Player relies on the hardware acceleration capabilities of the product it runs on. For instance some products do not support HEVC(H.265) hardware decoding and revert to software decoding yielding to a choppy video playback.  

In any case please make sure that you have not forced software decoding in the settings of Nova Video Player (Settings/Software decoding).

## What are the network share protocols supported by Nova?

Several network share protocols are supported by Nova:

* SMB: server message block version 1 to 3 usually on port 445. This is the recommended protocol to play videos;
* UPnP: universal plug and play (some servers not supported, verified to work with synology and minidlna);
* FTP: file transfer protocol on port 21 by default (some server types not supported);
* FTPS: FTP secure on port 21 by default (some server types not supported);
* SFTP: secure FTP on port 22 by default. This is the recommdended protocol to play videos when using remote access;
* WEBDAV: web-based distributed authoring and versioning over http (port 80 or 5005 on a synology)
* WEBDAVS: webdav over https (port 443 or 5006 on a synology)

## What is the best network protocol to play high bitrate video files?

According to benchmarks, sftp and webdav are the best network protocols to play high bitrate video files (e.g. large 4k).

Current SMB implementation is known to have difficulties to play 30Mbps videos.

Since nova version 6.2.x, you can select in nova settings another SMB implementation that supports higher throughput. Note that this option limits SMB operation to SMB servers with protocol version higher than 2, i.e.: SMB1 will not work.

## I cannot connect to a webdav server

When adding/browsing a webdav network shortcut, you need to fill the following dialog inputs:

* dropdown menu: to select webdav or webdavs network protocol (i.e.: http or https)
* server address: hostname/IP address (i.e. not an url) without specifying the path (e.g. [my.webdav.com](https://my.webdav.com))
* port: usually 443 for webdavs and 80 for webdav (on Synology NAS it is 5006 or 5005)
* path: url path for the server starting with a slash (e.g. `/dav`)

## How multimedia information is retrieved?

Nova relies on external services to retrieve multimedia information (descriptions and posters/backdrops) based on your video collection:

* [TheTVDB](https://www.thetvdb.com/) is used for TV shows
* [The Movie Database TMDB](https://www.themoviedb.org/) is used for movies

If you experience issues in the automatic scrape process, please check that it is not a backend service issue by directly seaching your movie/show on the [TheTVDB](https://thetvdb.com/search?query=) or [TMDB](https://www.themoviedb.org/).

More details are availble [here](https://github.com/nova-video-player/aos-AVP/wiki/Scrape:-retrieve-video-meta-data) and [here](https://github.com/nova-video-player/aos-AVP/wiki/Indexing).

Note that on Sony Android TVs, a rescan of USB disk is triggered at each power up/return from suspend and it is a Sony bug (cf. [here](https://github.com/nova-video-player/aos-AVP/issues/354)).

## Nova Video Player can’t find information on some of my videos, I’d like to add them manually.

Nova Video Player supports NFO file description format that follows the [Kodi specification](http://kodi.wiki/view/NFO_files/Movies).Advanced users can manually create them or use a dedicated tool for this task. More details are available [here](https://github.com/nova-video-player/aos-AVP/wiki/NFO-files).

## What type of subtitles are supported?

SRT, SUB subtitles are supported. SSA support is rudimentary. PGS subs are not yet supported.

## Which network shares are supported?

Nova Video Player supports adding videos on network shares using SMB, SFTP, FTP and FTPS protocols.
Note that:

* Nova is only compatible with ftp(s) servers supporting "recent" 2007 MLST command ([RFC3659](https://tools.ietf.org/html/rfc3659)), e.g. with proftpd but NOT with vsftpd;
* SMB1/2/3 are supported since v5.x version of Nova;
* Nova has UPnP support but issues can be experienced with remote subtitles support (UPnP has no native support for srt files). Nova is reported not to be compatible with Serviio media server.

## Blue screen starting nova

If you get an empty blue screen at application start, just reboot your device to get in a sane state.

## Resume points not working

Please check if you have enabled private mode which prevents resume points to be recorded.

## Trakt complains about no Internet connection

Trakt can report that there is no Internet connection when you use specific adblocking or a Pi-hole. In order to overcome this issue you need to whitelist these domains:

```
static.criteo.net
www.google-analytics.com
stats.g.doubleclick.net
```

## Dolby Vision and HDR

Dolby Vision and HDR support on AndroidTV depends on your TV capabilities, AV receiver passthrough compatibility and TV box hardware specification. This multifactor dependency is prone for confusion. 

Note that specific patches have been integrated in Nova v6.0.33 to improve DOVI support.

Dolby Vision requires specific HW support and TV box constructor in certain cases have to pay a specific license to benefit from this feature. This is the case for Amlogic S905Xx based hardware. Cheap chinese non certified hardware might not fullfil this requirement.

## Adaptive refresh rate on fire tv stick

In order to get adaptive refresh rate on Amazon fire tv stick you need to enable it in fireOS settings -> display & sounds -> Display, put video resolution to auto (up to 4k ultra hd); -> match original frame rate ON; -> dynamic range settings disable HDR or set it to adaptive. If you do not do this you will only have a restrictive set of refresh rates available.
Note that choosing adaptive for dynamic range setting, your UI will be 1080p, and disabled will enable a 4k UI.

## Visibility of external USB drive after Nvidia Shield Android 11+ update

In order to identify multimedia files, Nova relies on Android media scanning for local storage and USB storage. On latest version of the OS, Nvidia shield disables external storage Android indexing for performance enhancements. In order to get back external storage video files visibility, you need to enter Android settings/Device Preferences/Storage and enable Scan for media automatically option.

Alternatively you can expose in the same setting the local USB drive via SMB  (Mount network storage option) and then use Nova SMB network shares indexing.

## Pre-releases and Nova v5.xx to v6.xx migration

Nova v6.xx pre-release is available on [Github](https://github.com/nova-video-player/aos-AVP/releases):

* This new version upgrades the internal nova media database to a new scheme and any downgrade to v5 version of nova will wipe out your entire video collection to prevent any incompatibility.
* This version switches to theMovieDb for retrieving TV shows information instead of theTvDb. It is strongly recommended to rescrape all your TV shows or ***best to start from a fresh install***.
* Instead of going through a fresh install for proper support for movie collections and animation movies/series on AndroidTV you can perform the following manual steps. Acquisition of the additional movie collection informations and movies/TV series genres realignment requires a full rescrape of your video without interference of existing .nfo files (that do not yet contain the required information). For that purpose the following steps should do the trick:
    * backup all your customized handcrafted .nfo file (if you have any)
    * install nova version 6.xx
    * in nova settings unselect "process '.nfo' files"
    * in nova settings launch a "rescrape all" and wait for completion
    * in nova settings launch an "export already scraped videos" and wait for completion (**this step will override any existing .nfo file**)
* Versions later than v6.0.30 targets API31 and due to Android storage restrictions for API30, local NFO/JPG media information files for videos stored on local storage have been moved to nova public application folder located /sdcard/Android/data/org.courville.nova/files/nfoPoster 
 * If you ever want to get back to nova v5.xx, you will need to clean application data ***and cache***

## I’d like to request a new feature.

Feel free to join our [Reddit community](https://www.reddit.com/r/NovaVideoPlayer) or open a feature request on [github project issue](https://github.com/nova-video-player/aos-AVP/issues) .

## I'd like to report a bug

When discussing an issue on reddit, it is best also to report it on [github project issue](https://github.com/nova-video-player/aos-AVP/issues) with details about your specific configuration/setup/hardware/Android version and if possible a way or link or sample to reproduce the problem. It is also best to include logs to help figuring out the problem ([debugging procedure](https://github.com/nova-video-player/aos-AVP/wiki/Debugging)).

## How can I contribute in the development?

Source code is available on [github](https://github.com/nova-video-player/aos-AVP) and pull requests are welcome.

## The application does not support my language, how can I help?

You are welcome to contribute to the translation of the application via [crowdin service](https://crowdin.com/project/nova-video-player)

## Where to find Nova Video Player application privacy policy?

Nova application privacy policy can be found [here](https://home.courville.org/nova_video_player-faq/privacy.html).

## I want to sponsor Nova.

You are always welcome to show your gratitude and appreciation to the developers of this application through a donation via [liberapay](https://liberapay.com/NovaVideoPlayer/donate) or [github sponsor](https://github.com/sponsors/courville) or [opencollective](https://opencollective.com/novavideoplayer).

