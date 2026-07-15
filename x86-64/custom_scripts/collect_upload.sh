#!/bin/sh

ROOTFS_TAR_GZ=$(find ./bin/targets/ -type f -name "*wrt-*-rootfs.tar.gz" 2>/dev/null | head -n1)
SQUASHFS_IMG_GZ=$(find ./bin/targets/ -type f -name "*wrt-*-squashfs.img.gz" 2>/dev/null | head -n1)

mkdir -p $GITHUB_WORKSPACE/$UPLOAD_DIR

cp -rf .config $GITHUB_WORKSPACE/$UPLOAD_DIR/
mv $ROOTFS_TAR_GZ $GITHUB_WORKSPACE/$UPLOAD_DIR/
mv $SQUASHFS_IMG_GZ $GITHUB_WORKSPACE/$UPLOAD_DIR/
