#!/bin/sh

mkdir -p "$GITHUB_WORKSPACE/$UPLOAD_DIR"

cp -f .config "$GITHUB_WORKSPACE/$UPLOAD_DIR/"

# 查找并移动所有匹配的 img.gz 文件
find ./bin/targets/ -type f -name "*wrt*.img.gz" -exec mv {} "$GITHUB_WORKSPACE/$UPLOAD_DIR/" \; 2>/dev/null

