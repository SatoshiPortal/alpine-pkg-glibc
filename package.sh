#!/usr/bin/env bash

docker rm -f input

docker create --name input --volume /home/builder/package alpine:3.12.4 /bin/true
docker cp . input:/home/builder/package/

docker run -it --volumes-from input \
 -e RSA_PRIVATE_KEY_NAME="cyphernode@satoshiportal.com.rsa" \
 -e PACKAGER="Cyphernode Team <cyphernode@satoshiportal.com>" \
 -e PACKAGER_PRIVKEY="/home/builder/.abuild/cyphernode@satoshiportal.com.rsa" \
 -v "$PWD/.abuild:/home/builder/.abuild" \
 -v "$PWD/.abuild/packages:/packages" \
 -v "$PWD/.abuild/cyphernode@satoshiportal.com.rsa.pub:/etc/apk/keys/cyphernode@satoshiportal.com.rsa.pub" \
 cyphernode/alpine-abuild
