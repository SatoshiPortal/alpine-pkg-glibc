#!/usr/bin/env bash

docker rm -f input

docker create --name input --volume /home/builder/package alpine:3.9 /bin/true
docker cp . input:/home/builder/package/

docker run --volumes-from input  --volume $(pwd)/ssh.rsa:/home/builder/ssh.rsa --volume $(pwd)/apk:/packages cyphernode/alpine-abuild
