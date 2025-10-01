## What is Nova Video Player?

NOVA is an opeN sOurce Video plAyer designed for Android devices (tablets, phones and TVs).  
This application is based on a fork of Archos Video Player open-source release, intended to support new features with an enhanced stability.

NOVA is published on [GooglePlay](https://play.google.com/store/apps/details?id=org.courville.nova) or on [Amazon Appstore](https://www.amazon.fr/dp/B07P1Q1DG9) or on [F-Droid](https://f-droid.org/en/packages/org.courville.nova/) or on [IzzyOnDroid](https://apt.izzysoft.de/fdroid/index/apk/org.courville.nova) or directly on [github](https://github.com/nova-video-player/aos-AVP/releases). 
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

On some devices (e.g. Chromecast with Google TV) trying to play dolby vision videos on a non dolby vision capable display/TV results in choppy video playback. If this happens try to "Disable dolby vision" in Nova settings (that forces to use non dolby vision codecs).

## Which network shares are supported?

Several network share protocols are supported by Nova:

* SMB: server message block version 1 to 3 usually on port 445. This is the recommended protocol to play videos;
* UPnP: universal plug and play (some servers not supported, verified to work with synology and minidlna);
* FTP: file transfer protocol on port 21 by default (some server types not supported);
* FTPS: FTP secure on port 21 by default (some server types not supported);
* SFTP: secure FTP on port 22 by default. This is the recommdended protocol to play videos when using remote access;
* WEBDAV: web-based distributed authoring and versioning over http (port 80 or 5005 on a synology)
* WEBDAVS: webdav over https (port 443 or 5006 on a synology)

Note that:

* Nova is only compatible with ftp(s) servers supporting "recent" 2007 MLST command ([RFC3659](https://tools.ietf.org/html/rfc3659)), e.g. with proftpd but NOT with vsftpd;
* Nova has UPnP support but issues can be experienced with remote subtitles support (UPnP has no native support for srt files). Nova is reported not to be compatible with Serviio media server;
* Two types of SMB protocols are supported: smbj and jcifs-ng (smb). smbj is known to provide higher throughput but only supports SMB2+ protocols (not SMB1), use this one to play high bitrate videos;
* sshj seems to be a faster implementation for sftp.

## What is the best network protocol to play high bitrate video files?

According to benchmarks, sftp and webdav are the best network protocols to play high bitrate video files (e.g. large 4k).

Current default SMB implementation based on jcifs-ng is known to have difficulties to play high bitrate videos. smbj is an alternate SMB implementation pwhich erforms better but only supports SMB servers with protocol version higher than 2, i.e.: SMB1 will not work with smbj.

## I cannot connect to a webdav server.

When adding/browsing a webdav network shortcut, you need to fill the following dialog inputs:

* dropdown menu: to select webdav or webdavs network protocol (i.e.: http or https);
* server address: hostname/IP address (i.e. not an url) without specifying the path (e.g. [my.webdav.com](https://my.webdav.com));
* port: usually 443 for webdavs and 80 for webdav (on Synology NAS it is 5006 or 5005);
* path: url path for the server starting with a slash (e.g. `/dav`).

## How multimedia information is retrieved?

Nova relies on [The Movie Database TMDB](https://www.themoviedb.org/) external services to retrieve multimedia information (descriptions and posters/backdrops) based on your video collection both for movies and TV shows.

Note that on Sony Android TVs, a rescan of USB disk is triggered at each power up/return from suspend and it is a Sony bug (cf. [here](https://github.com/nova-video-player/aos-AVP/issues/354)).

## Nova Video Player can’t find information on some of my videos, I’d like to add them manually.

Nova Video Player supports NFO file description format that follows the [Kodi specification](https://kodi.wiki/view/NFO_files/Movies).Advanced users can manually create them or use a dedicated tool for this task. More details are available [here](https://github.com/nova-video-player/aos-AVP/wiki/NFO-files).
Note that Nova only supports The Movie Database identifiers (tmdbid).

## What type of subtitles are supported?

SRT, SUB, VOBSUB, PGS subtitles are supported. SSA support is rudimentary.

## Blue screen starting nova.

If you get an empty blue screen at application start, just reboot your device to get in a sane state.

## Resume points are not working.

Please check if you have enabled private mode which prevents resume points to be recorded.

## Is this possible to synchronize video resume points between devices?

On network shares with writeable access, after playing a video e.g. `video.mkv`, nova saves a `.video.mkv.archos.resume.xml` file containing the resume point.
This file is recognized between devices accessing the same network share.

Another method is to use [Trakt](https://trakt.tv/) live scrobling feature. Do register to trakt via your PC using email address and then sign in in nova settings. 
Note that only the last 100 played entries are synced from trakt to reduce network overhead.

## Trakt complains about no Internet connection.

Trakt can report that there is no Internet connection when you use specific adblocking (Pi-hole or AdGuard). In order to overcome this issue you need to whitelist these domains:

```
static.criteo.net
www.google-analytics.com
stats.g.doubleclick.net
```

With AdGuard you need to add the following corresponding personalized filtering rules:

```
@@||static.criteo.net^
@@||www.google-analytics.com^
@@||stats.g.doubleclick.net^
```

## What are the different play modes.

Nova is able to play video files sequentially by choosing a play mode. This option is selectable when playing the video in one of the accessible menus. The various available play modes are:

* Single (default one): play a single video and then stop;
* Folder: play all the files sequentially in the folder of the file that initiated the playback and stop at after the last one has been played;
* Repeat single: repeat in loop the video played;
* Repeat folder: play all the files sequentially in the folder of the file that initiated the playback, and repeat this process in loop;
* Binge watching: play TV show episodes sequentially even if they are not located in the same folder and stop at the last one of the last season available.

## Dolby Vision and HDR.

Dolby Vision and HDR support on AndroidTV depends on your TV capabilities, AV receiver passthrough compatibility and TV box hardware specification. This multifactor dependency is prone for confusion. 

Note that specific patches have been integrated in Nova v6.0.33 to improve DOVI support.

Dolby Vision requires specific HW support and TV box constructor in certain cases have to pay a specific license to benefit from this feature. This is the case for Amlogic S905Xx based hardware. Cheap chinese non certified hardware might not fullfil this requirement.

## Washy colors on the TV.

It can happen that the bottom and top bars instead of being black are with a greyish color and that video seems to have a kind a veil that makes the image washy.

This is due to a wrong HDMI display mode selected that has a color space not compatible with the video color format.

In order to overcome the issue, on some hardware (e.g. nvidia shield), you can disable the adaptive refresh rate on nova and force the display mode to be used going through Android setting in display/audio->advanced to match color space to content color format one.

Most often the washy colors happen using RGB8 and not with YUV420 (RGB/8/Rec.709 NOK, YUV420/8/Rec.709 OK, YUV422/12/Rec.2020/hdr OK, YUV422/10/Rec.2020/hdr OK).

One can check the compatible display modes of your device through `adb shell dumpsys SurfaceFlinger`. The video color format used can be checked with FFMpeg `ffprobe` command.

Best is to use HDMI 2.1 compativle devices and be aware that you can deteriorate the experience if you have a sound bar that would be only HDMI 1.4 capable between your Android TV box and your TV.

## Adaptive refresh rate on fire tv stick.

In order to get adaptive refresh rate on Amazon fire tv stick you need to enable it in fireOS settings -> display & sounds -> Display, put video resolution to auto (up to 4k ultra hd); -> match original frame rate ON; -> dynamic range settings disable HDR or set it to adaptive. If you do not do this you will only have a restrictive set of refresh rates available.
Note that choosing adaptive for dynamic range setting, your UI will be 1080p, and disabled will enable a 4k UI.

## Visibility of external USB drive on Nvidia Shield.

In order to identify multimedia files, Nova relies on Android media scanning for local storage and USB storage. On latest version of the OS, Nvidia shield disables external storage Android indexing for performance enhancements. In order to get back external storage video files visibility, you need to enter Android settings/Device Preferences/Storage and enable Scan for media automatically option.

Alternatively you can expose in the same setting the local USB drive via SMB  (Mount network storage option) and then use Nova SMB network shares indexing.

## Nova shuts down my Wi-Fi.

On some devices due to some manufacturer Wi-Fi driver instability (e.g. Fire 10 HD), Nova's UDP SMB discovery process may cause Wi-Fi to switch off. 
In order to avoid this issue, select "Disable SMB UDP discovery" in Nova settings.

## Opensubtitles login issues after v6.2.40.

Note that you need to use your opensubtitles.com credentials (not your opensubtitle.org one) and input your username (not your email) to login to opensubtitles.com.

Opensubtitles has announced to all app developers that starting January 2024, XML-RPC will not be supported anymore and that REST-API needs to be used (cf. https://github.com/nova-video-player/aos-AVP/issues/852).

As a consequence, old opensubtitles.org logins will not be supported anymore and users need to register an account at opensubtitles.com to continue to use the service with nova.

Note that there is a download quota of 5 subs per IP and per 24 hours without inputing credentials and 10-20 with a registered account.

The remaining quota will be reported when downloading subs by nova.

I managed to get 20 subs quota per day (instead of the 10 I had initially) by clicking on the "IF YOUR DOWNLOAD LIMIT IS WRONG, CLICK HERE TO FIX IT" found at https://www.opensubtitles.com/fr/users/profile. It might work for you too if you are in this situation (could be a sign-in before 2024 boost).

## Some files located on local/USB storage are not seen by nova a.k.a. API31 debacle.

For good reasons Google restricts `MANAGE_EXTERNAL_STORAGE` permission since API31.
Nova thus switched to MediaStore API.
As a consequence nova is only able to see files registered as Media files by Google (missing video/subtitles formats such as ASS, NFO, torrent files).
These files are not modifiable nor visible from nova when using local storage (incl. USB HDDs).
This creates loss of functionality & incomprehension from nova users.
Numerous appeals were issued & proper request filed for being granted the permission with explanation video.
Only got default "no answers"/"not compliant" without having a Google support taking time to understand/review the case properly.
Note that many other video players have the wanted `MANAGE_EXTERNAL_STORAGE` permission: e.g. VLC, mx player, video player all format, Video Player KMP, kodi...
I consider this as unfair treatment and discrimination.
Sad that an app that has more than 500k active users and 2M downloads on Google Play cannot get proper attention from Google.

## Where NFO files, posters/banners are located.

Due to Android storage restrictions for API31, local NFO/JPG media information files for videos stored on local/HDD storage have been moved to nova public application folder located `/sdcard/Android/data/org.courville.nova/files/nfoPoster`.

Note that due to API31 restrictions, NFO files co-located with videos on local storage are invisible to nova since Google refuses to grant `MANAGE_EXTERNAL_STORAGE` permission to nova (cf. section above).

## How to exclude some folders from media indexing?

For local storage or remote network shares, creating a `.nomedia` empty file in a folder will instruct nova to not index the video files included in this folder.
Note that this is a global Android practice and since nova is relying on Android multimedia indexing for local storage, it is inherently supported.

## Audio boost effect acts temporarily

This can be avoided by selecting PCM instead of Automatic in Android All settings -> Display & Sound -> Advanced sound settings -> Select formats.
This option removes the adaptive normalization of the sound that seems to be Android TV default behavior canceling nova's boost mode after a while.

## What are the touch zones and gestures in the video player?

Nova Video Player supports multiple touch gestures and zones for different controls:

<div style="text-align: center; margin: 20px 0;">
  <div style="display: inline-block; border: 2px solid #333; background: #f8f8f8; font-family: monospace; position: relative;">
    <div style="background: #333; color: white; padding: 8px; text-align: center; font-weight: bold;">
      NOVA VIDEO PLAYER TOUCH ZONES
    </div>
    <table style="border-collapse: collapse; width: 500px; height: 350px;">
      <tr>
        <td style="width: 25%; padding: 0;">
          <table style="border-collapse: collapse; width: 100%; height: 350px;">
            <tr style="height: 75%; border-bottom: 2px solid #ff6b6b;">
              <td style="border: 1px solid #666; text-align: center; background: #e8f4fd; vertical-align: middle;">
                <strong>LEFT TOP</strong><br>
                <small>🔊 SCROLL: Volume</small><br><br>
                <strong>⏪ DOUBLE TAP:</strong><br>
                <strong>Rewind 10s</strong>
              </td>
            </tr>
            <tr style="height: 25%;">
              <td style="border: 1px solid #666; text-align: center; background: #f0e8ff; vertical-align: middle;">
                <strong>LEFT BOTTOM</strong><br>
                <strong>🔽 DOUBLE TAP:</strong><br>
                <strong>Speed Down (-0.05×)</strong><br>
                <small>(requires speed setting enabled)</small>
              </td>
            </tr>
          </table>
        </td>
        <td style="border: 1px solid #666; text-align: center; background: #fff2e8; width: 50%; vertical-align: middle;">
          <strong>CENTRAL ZONE</strong><br>
          <small>(middle 1/3 of screen - FULL HEIGHT)</small><br><br>
          <strong>📱 SINGLE TAP:</strong><br>
          • If playing ▶️: Pause ⏸️ + Show OSD<br>
          • If paused ⏸️: Resume ▶️ + Hide OSD<br><br>
          <small style="color: #666;">Outside zones: Single tap = OSD toggle only</small><br><br>
          <small style="color: #999;">No 75%/25% split here</small>
        </td>
        <td style="width: 25%; padding: 0;">
          <table style="border-collapse: collapse; width: 100%; height: 350px;">
            <tr style="height: 75%; border-bottom: 2px solid #ff6b6b;">
              <td style="border: 1px solid #666; text-align: center; background: #e8f4fd; vertical-align: middle;">
                <strong>RIGHT TOP</strong><br>
                <small>☀️ SCROLL: Brightness</small><br><br>
                <strong>⏩ DOUBLE TAP:</strong><br>
                <strong>Forward 10s</strong>
              </td>
            </tr>
            <tr style="height: 25%;">
              <td style="border: 1px solid #666; text-align: center; background: #f0e8ff; vertical-align: middle;">
                <strong>RIGHT BOTTOM</strong><br>
                <strong>🔼 DOUBLE TAP:</strong><br>
                <strong>Speed Up (+0.05×)</strong><br>
                <small>(requires speed setting enabled)</small>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <div style="position: absolute; right: -120px; top: 120px; font-size: 12px; color: #666;">
      ← TOP 75%
    </div>
    <div style="position: absolute; right: -140px; top: 290px; font-size: 12px; color: #666;">
      ← BOTTOM 25%
    </div>
  </div>
</div>


**Gesture Summary:**

- **Single Tap Central Zone**: Toggle pause/play (pause shows OSD, resume hides OSD)
- **Single Tap Outside**: Toggle OSD controls only (no pause/play change)
- **Double Tap Top 75% Left**: Rewind 10 seconds
- **Double Tap Top 75% Right**: Fast forward 10 seconds
- **Double Tap Bottom 25% Left**: Decrease audio playback speed (-0.05×)
- **Double Tap Bottom 25% Right**: Increase audio playback speed (+0.05×)
- **Scroll Left Side**: Adjust volume
- **Scroll Right Side**: Adjust screen brightness

**Notes:**

- Audio speed control requires the playback speed feature to be enabled in settings
- When the player is locked, all gestures show unlock instructions instead
- The central zone spans the middle third of the screen horizontally (full height)
- Central zone behavior is based on playback state, not OSD visibility

## What keyboard shortcuts are available?

Nova Video Player supports various keyboard shortcuts for different input devices:

**Playback Controls:**

- **Space/P/Enter**: Toggle play/pause
- **D-Pad Right/Left**: Seek forward/backward 
- **0-9**: Jump to 0-90% of video timeline

**Volume Controls:**

- **Volume Up/U, Volume Down/D**: Adjust volume
- **\* (Star)**: Increase volume
- **/ (Slash)**: Decrease volume

**Video/Audio/Subtitle Controls:**

- **F**: Switch video format
- **O**: Toggle overlays
- **A/#**: Switch audio track
- **S/J**: Switch subtitle track
- **Z/X**: Adjust subtitle delay

**Navigation:**

- **Menu/D-Pad Up**: Show/hide TV menu
- **Escape/Back**: Close TV menu

**Playback Speed** (requires speed setting enabled):

- **Channel Up/H**: Increase speed (+0.05×)
- **Channel Down/G**: Decrease speed (-0.05×)

For the complete list of shortcuts including TV remote controls, see the [keyboard shortcuts wiki](https://github.com/nova-video-player/aos-AVP/wiki/Keyboard-shortcuts).

## I'd like to request a new feature.

Feel free to join our [Reddit community](https://www.reddit.com/r/NovaVideoPlayer) or open a feature request on [github project issue](https://github.com/nova-video-player/aos-AVP/issues).

## I'd like to report a bug.

When discussing an issue on reddit, it is best also to report it on [github project issue](https://github.com/nova-video-player/aos-AVP/issues) with details about your specific configuration/setup/hardware/Android version and if possible a way or link or sample to reproduce the problem. It is also best to include logs to help figuring out the problem ([debugging procedure](https://github.com/nova-video-player/aos-AVP/wiki/Debugging)).

## How can I contribute in the development?

Source code is available on [github](https://github.com/nova-video-player/aos-AVP) and associated repositories and pull requests are welcome.

## The application does not support my language, how can I help?

You are welcome to contribute to the translation of the application via [crowdin platform](https://crowdin.com/project/nova-video-player).

## Where to find Nova Video Player application privacy policy?

Nova application privacy policy can be found [here](https://home.courville.org/nova_video_player-faq/privacy.html).

## I want to sponsor Nova.

You are always welcome to show your gratitude and appreciation to the developers of this application through a donation via [paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=software%40courville.org&lc=US&item_name=Nova+Video+Player+Donation&no_note=0&no_shipping=1&currency_code=EUR), or [liberapay](https://liberapay.com/NovaVideoPlayer/donate) or [github sponsor](https://github.com/sponsors/courville) or [opencollective](https://opencollective.com/novavideoplayer).

