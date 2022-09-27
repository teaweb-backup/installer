#!/usr/bin/env bash

ARCH="${1}"
if [ "${ARCH}" = "" ]
then
	ARCH=amd64
fi

#{"code":200,"message":"","data":{"latest":"0.1.12","hasNew":true}}
#VERSION_DATA=`curl -s "http://teaos.cn/services/version"`
VERSION_DATA='{"code":200,"message":"","data":{"latest":"0.1.12","hasNew":true}}'
if [ "${VERSION_DATA}" = "" ]
then
	echo "Failed: Failed to connect teaweb official site"
	exit
fi

VERSION_DATA=${VERSION_DATA#*"latest\":\""}
VERSION=${VERSION_DATA%%[!0-9.]*}

if [ "${VERSION}" = "" ]
then
	echo "Failed: Unable to connect teaweb official site"
	exit
fi

if [ -d "/usr/local/teaweb-v${VERSION}" ]
then
	echo "Failed: Target already exists '/usr/local/teaweb-v${VERSION}'"
	exit
fi

UNZIP=`which unzip`
if [ "${UNZIP}" = "" ]
then
	echo "Failed: Please install 'unzip' command"
	exit
fi

FILE="teaweb-linux-${ARCH}-v${VERSION}.zip"

if [ -f "${FILE}" ]
then
	unlink "${FILE}"
fi

if [ -d "teaweb-v${VERSION}" ]
then
	rm -rf "teaweb-v${VERSION}"
fi

echo "Downloading: ${FILE} ..."
#curl -o "${FILE}" "http://dl.teaos.cn/v${VERSION}/${FILE}"
curl -o "${FILE}" "https://github.com/teaweb-backup/assets/releases/download/teaweb-${VERSION}/${FILE}"
unzip -q "${FILE}"

if [ ! -d "/usr/local" ]
then
	mkdir -p /usr/local
fi

if [ `pwd` != "/usr/local" ]
then
	mv "teaweb-v${VERSION}" "/usr/local/"
	if [ ! -d "/usr/local/teaweb-v${VERSION}" ]
	then
		echo "Failed"
		exit
	fi
fi

# install service
/usr/local/teaweb-v${VERSION}/bin/service-install

# start
sleep 2
/usr/local/teaweb-v${VERSION}/bin/teaweb start

echo "[success]"