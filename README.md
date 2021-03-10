# Satoshi Portal, what we did

## Getting everything

```
git clone https://github.com/SatoshiPortal/docker-alpine-abuild.git
git clone https://github.com/satoshiportal/docker-glibc-builder.git
git clone https://github.com/satoshiportal/alpine-pkg-glibc

cd docker-glibc-builder/
docker build -t cyphernode/glibc-builder .
cd ../docker-alpine-abuild/
docker build -t cyphernode/alpine-abuild .
```

## Our keys

You can find our public key at https://raw.githubusercontent.com/SatoshiPortal/alpine-pkg-glibc/master/.abuild/cyphernode@satoshiportal.com.rsa.pub

We generated them with:

```
docker run --name keys --entrypoint abuild-keygen -e PACKAGER="Cyphernode Team <cyphernode@satoshiportal.com>" cyphernode/alpine-abuild -n
docker cp keys:/home/builder/.abuild/cyphernode@satoshiportal.com-5cd07e40.rsa ./
docker cp keys:/home/builder/.abuild/cyphernode@satoshiportal.com-5cd07e40.rsa.pub ./
docker rm -f keys
```

## Building glibc

```
cd ../alpine-pkg-glibc/
cp ../docker-alpine-abuild/cyphernode@satoshiportal.com.rsa* .abuild/
chmod 600 .abuild/cyphernode@satoshiportal.com.rsa
docker run --name glibc-binary cyphernode/glibc-builder 2.33 /usr/glibc-compat
docker cp glibc-binary:/glibc-bin-2.33.tar.gz ./
docker rm glibc-binary
```

## Building the APK

### x86_64

```
mv glibc-bin-2.33.tar.gz glibc-bin-2.33-0-x86_64.tar.gz
cp APKBUILD-x86_64 APKBUILD
```

### aarch64 (ARM64)

```
mv glibc-bin-2.33.tar.gz glibc-bin-2.33-0-aarch64.tar.gz
cp APKBUILD-aarch64 APKBUILD
```

### armhf (arm32)

```
mv glibc-bin-2.33.tar.gz glibc-bin-2.33-0-armhf.tar.gz
cp APKBUILD-armhf APKBUILD
```

### All arch

```
chmod +x package.sh
vi package.sh
./package.sh
```

## Prepare release

### x86_64

```
cp glibc-bin-2.33-0-x86_64.tar.gz .abuild/packages/builder/x86_64/
cd .abuild/packages/builder/x86_64
mv APKINDEX.tar.gz APKINDEX-x86_64.tar.gz
mv glibc-2.33-r0.apk glibc-2.33-r0-x86_64.apk
mv glibc-bin-2.33-r0.apk glibc-bin-2.33-r0-x86_64.apk
mv glibc-dev-2.33-r0.apk glibc-dev-2.33-r0-x86_64.apk
mv glibc-i18n-2.33-r0.apk glibc-i18n-2.33-r0-x86_64.apk
shasum -a 256 glibc-2.33-r0-x86_64.apk glibc-bin-2.33-r0-x86_64.apk > SHA256SUMS.asc
```

### aarch64

```
cp glibc-bin-2.33-0-aarch64.tar.gz .abuild/packages/builder/aarch64/
cd .abuild/packages/builder/aarch64
mv APKINDEX.tar.gz APKINDEX-aarch64.tar.gz
mv glibc-2.33-r0.apk glibc-2.33-r0-aarch64.apk
mv glibc-bin-2.33-r0.apk glibc-bin-2.33-r0-aarch64.apk
mv glibc-dev-2.33-r0.apk glibc-dev-2.33-r0-aarch64.apk
mv glibc-i18n-2.33-r0.apk glibc-i18n-2.33-r0-aarch64.apk
shasum -a 256 glibc-2.33-r0-aarch64.apk glibc-bin-2.33-r0-aarch64.apk >> SHA256SUMS.asc
```

### x86_64

```
cp glibc-bin-2.33-0-armhf.tar.gz .abuild/packages/builder/armhf/
cd .abuild/packages/builder/armhf
mv APKINDEX.tar.gz APKINDEX-armhf.tar.gz
mv glibc-2.33-r0.apk glibc-2.33-r0-armhf.apk
mv glibc-bin-2.33-r0.apk glibc-bin-2.33-r0-armhf.apk
mv glibc-dev-2.33-r0.apk glibc-dev-2.33-r0-armhf.apk
mv glibc-i18n-2.33-r0.apk glibc-i18n-2.33-r0-armhf.apk
shasum -a 256 glibc-2.33-r0-armhf.apk glibc-bin-2.33-r0-armhf.apk >> SHA256SUMS.asc
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
