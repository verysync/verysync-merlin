#!/bin/sh

PACKAGE_VERSION=$1
if [[ "$PACKAGE_VERSION" == "" ]]; then
    echo "Usage: $0 version"
    exit 1
fi

gsed -i 's/^PACKAGE_VERSION=.*/PACKAGE_VERSION=$PACKAGE_VERSION/' install.sh
tar czvf dist/verysync-v$PACKAGE_VERSION.tar.gz verysync
