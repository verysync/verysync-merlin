#!/bin/sh

PACKAGE_VERSION=$1
if [[ "$PACKAGE_VERSION" == "" ]]; then
    echo "Usage: $0 version"
    exit 1
fi

<<<<<<< HEAD
gsed -i "s/^PACKAGE_VERSION=.*/PACKAGE_VERSION=$PACKAGE_VERSION/" verysync/install.sh
=======
gsed -i 's/^PACKAGE_VERSION=.*/PACKAGE_VERSION=$PACKAGE_VERSION/' install.sh
>>>>>>> 25f736630d5db3490001003b633850f32faba6b6
tar czvf dist/verysync-v$PACKAGE_VERSION.tar.gz verysync
