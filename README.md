# Satoshi Portal, what we did

## Build abuild

```
git clone https://github.com/SatoshiPortal/docker-alpine-abuild.git
cd docker-alpine-abuild/
docker build -t cyphernode/alpine-abuild .
```

## Our keys

```
docker run --name keys --entrypoint abuild-keygen -e PACKAGER="Cyphernode Team <cyphernode@satoshiportal.com>" cyphernode/alpine-abuild -n
mkdir ~/.abuild
docker cp keys:/home/builder/.abuild/cyphernode@satoshiportal.com-5cd07e40.rsa ~/.abuild/
docker cp keys:/home/builder/.abuild/cyphernode@satoshiportal.com-5cd07e40.rsa.pub ~/.abuild/
```

## Builder

```
git clone https://github.com/satoshiportal/docker-glibc-builder.git
cd docker-glibc-builder/
docker build -t cyphernode/glibc-builder .
cd ../builder
docker run --name glibc-binary cyphernode/glibc-builder 2.29 /usr/glibc-compat
```

```
docker cp glibc-binary:/glibc-bin-2.29.tar.gz ./
mv glibc-bin-2.29.tar.gz glibc-bin-2.29-0-x86_64.tar.gz
mv glibc-bin-2.29.tar.gz glibc-bin-2.29-0-aarch64.tar.gz
mv glibc-bin-2.29.tar.gz glibc-bin-2.29-0-armhf.tar.gz
docker rm glibc-binary
```

## Packager

```
git clone https://github.com/satoshiportal/alpine-pkg-glibc
cd alpine-pkg-glibc/
./package.sh
```


# alpine-pkg-glibc

[![CircleCI](https://circleci.com/gh/sgerrand/alpine-pkg-glibc/tree/master.svg?style=svg)](https://circleci.com/gh/sgerrand/alpine-pkg-glibc/tree/master) ![x86_64](https://img.shields.io/badge/x86__64-supported-brightgreen.svg)

This is the [GNU C Library](https://gnu.org/software/libc/) as a Alpine Linux package to run binaries linked against `glibc`. This package utilizes a custom built glibc binary based on the vanilla glibc source. Built binary artifacts come from https://github.com/sgerrand/docker-glibc-builder.

## Releases

See the [releases page](https://github.com/sgerrand/alpine-pkg-glibc/releases) for the latest download links. If you are using tools like `localedef` you will need the `glibc-bin` and `glibc-i18n` packages in addition to the `glibc` package.

## Installing

The current installation method for these packages is to pull them in using `wget` or `curl` and install the local file with `apk`:

    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk
    apk add glibc-2.33-r0.apk

### Please Note

:warning: The URL of the public signing key has changed! :warning:

Any previous reference to `https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub` should be updated with immediate effect to `https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub`.

## Locales

You will need to generate your locale if you would like to use a specific one for your glibc application. You can do this by installing the `glibc-i18n` package and generating a locale using the `localedef` binary. An example for en_US.UTF-8 would be:

    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-bin-2.33-r0.apk
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-i18n-2.33-r0.apk
    apk add glibc-bin-2.33-r0.apk glibc-i18n-2.33-r0.apk
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
