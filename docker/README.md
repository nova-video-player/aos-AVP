### nova dockerfile

Please see the entry point repo: https://github.com/archos-sa/aos-AVP

This git repo is part of NOVA opeN sOurce Video plAyer, a video player software for Android. Please see the entry point repo: https://github.com/nova-video-player/aos-AVP

This Dockerfile provides a way to build nova in a linux debian docker.

```
docker build -t nova .
docker run --rm -ti --entrypoint=/bin/bash nova2
```
