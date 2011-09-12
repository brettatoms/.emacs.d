#!/bin/sh

EMACS_DIR="~/.emacs.d/"
PACKAGE_DIR="$EMACS_DIR/packages"
DVC_DEV_DIR="$PACKAGE_DIR/dvc-dev"
BUILD_DIR="$DVC_DEV_DIR/++build"

# TODO: if DVC_DEV_DIR already exists then try to just pull recent
# updates
bzr get http://bzr.xsteve.at/dvc/ $DVC_DEV_DIR
cd $DVC_DEV_DIR
autoconf
mkdir -p $BUILD_DIR
cd $BUILD_DIR
../configure
make
ln -s $BUILD_DIR $PACKAGE_DIR/dvc