#!/bin/sh

SQUASHFS_IMG_GZ=$(find ./bin/targets/ -type f -name "*wrt*.img.gz" 2>/dev/null)

mkdir -p $GITHUB_WORKSPACE/$UPLOAD_DIR

cp -rf .config "$GITHUB_WORKSPACE/$UPLOAD_DIR/"

[ -f "$SQUASHFS_IMG_GZ" ] && mv "$SQUASHFS_IMG_GZ" "$GITHUB_WORKSPACE/$UPLOAD_DIR/" || echo "未找到 img 文件，跳过"
