#!/bin/sh

ROOTFS_TAR_GZ=$(find ./bin/targets/ -type f -name "*wrt-*-rootfs.tar.gz" 2>/dev/null | head -n1)
SQUASHFS_IMG_GZ=$(find ./bin/targets/ -type f -name "*wrt-*-squashfs-*-efi.img.gz" 2>/dev/null | head -n1)

mkdir -p $GITHUB_WORKSPACE/$UPLOAD_DIR

cp -rf .config "$GITHUB_WORKSPACE/$UPLOAD_DIR/"

[ -f "$ROOTFS_TAR_GZ" ] && mv "$ROOTFS_TAR_GZ" "$GITHUB_WORKSPACE/$UPLOAD_DIR/" || echo "未找到 rootfs 文件，跳过"
[ -f "$SQUASHFS_IMG_GZ" ] && mv "$SQUASHFS_IMG_GZ" "$GITHUB_WORKSPACE/$UPLOAD_DIR/" || echo "未找到 squashfs 文件，跳过"
