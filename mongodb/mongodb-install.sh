#!/usr/bin/env bash

TEAWEB_VERSION="0.1.12"
MONGO_VERSION="4.0.3"
MONGO_URL="https://github.com/teaweb-backup/assets/releases/download/mongodb-${MONGO_VERSION}/mongodb-linux-x86_64-${MONGO_VERSION}.tgz"
MONGODB_DIR="/usr/local/teaweb-v${TEAWEB_VERSION}/mongodb"

if [ ! -d "/usr/local/teaweb-v${TEAWEB_VERSION}" ]
then
	echo "Directory /usr/local/teaweb-v${TEAWEB_VERSION} not found"
	exit
fi

if [ -d "${MONGODB_DIR}" ]
then
	echo "Directory ${MONGODB_DIR} exists, remove to continue"
	exit
fi

echo "Downloading ${MONGO_URL}";
curl -Lo mongodb-linux-x86_64-${MONGO_VERSION}.tgz ${MONGO_URL}

tar -zxvf mongodb-linux-x86_64-${MONGO_VERSION}.tgz;
mv mongodb-linux-x86_64-${MONGO_VERSION} ${MONGODB_DIR};