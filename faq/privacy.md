
## Introduction
This privacy policy covers the use of the 'Nova Video Player' Android application.

It may not be applicable to other software produced or released by Courville Software.

Please note that Courville Software is a non-profit organization based in France, operated by volunteers.

Nova Video Player when running does not collect any statistics, personal information, or analytics from its users, other than Android operating system built in mechanisms that are present for all the mobile applications.

Nova Video Player allows videos to be played on various network transports. Cookies are not stored at any point. Authentication credentials can be stored optionally on the user's local device upon the user's explicit request. Authentication credentials might be shared across devices using proprietary encryption mechanisms provided by the Android operating system. Courville Software does not have access to any such information.

## Third party cloud service dependencies

Note that Nova Video Player:

* relies on The Movie Database (TMDB) online service to retrieve multimedia information (posters/descriptions) of the user's video files present on the device or on indexed network shares. For this purpose only a processed version of the video file names present on the device is sent to themoviedb.org servers;
* has the ability, upon user request, to retrieve subtitles relying on the online OpenSubtitle service. For this purpose only a processed version of the video file names is sent to opensubtitle.org servers. This is performed with or without opensubtitles user credentials that are stored locally on the user’s device;
* allows online scrobbling, upon user activation, relying on trakt cloud service: this feature helps to keep record of what the user watchs on his personal TRAKT account. TRAKT user credentials that are stored locally on the user’s device. Optionnaly this service can store last video resume points and synchronize the whole movies and TV shows collection. For this pupose, trakt.tv servers are used and TMDB identifiers of the videos as well as watched resume points are synced;
 
Nova online FAQ or specific open-source licenses of libraries used in the application can be accessed from settings and generates web requests that might be logged on the web servers serving these information.

## Crash reports

When a user has opted-in to the Android vitals terms, when Nova Video Player application crashes, an anonymized crash report is automatically sent and available on Nova Video Player developpers Google Play console. This report includes Operating System/hardware product version and an anonymized stack trace of the process causing the crash.

Additionaly, only on github pre-release versions (not the Google Play releases), application might send detailed crash reports including stack traces to Nova developers private sentry.io instance in order to improve application quality prior to official releases.

## Android permissions requested by the application
Note that Nova Video Player application requires the following android platform permissions:

* “record audio” android permission in order to be able to rely on Android platform capability to perform voice search on Nova Video Player internal device media database to find a specific indexed movies or TV shows;
* “Internal storage” access in order to be able to index local storage multimedia video files.
