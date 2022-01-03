### nova dockerfile

Please see the entry point repo: https://github.com/archos-sa/aos-AVP

This git repo is part of NOVA opeN sOurce Video plAyer, a video player software for Android. Please see the entry point repo: https://github.com/nova-video-player/aos-AVP

This Dockerfile provides a way to build nova in a linux debian docker.

```
docker build -t nova .
mkdir shared
docker run --rm -ti -v $PWD/shared:/shared --entrypoint=/bin/bash nova
cd Video
./gradlew aND
cp /nova/Video/build/outputs/apk/noamazon/debug/*apk /shared
```

Built apk are located in docker folder `/nova/Video/build/outputs/apk/noamazon/debug` and are copied at the end in the `shared` folder with the host.
