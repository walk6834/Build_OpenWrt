#!/bin/sh

mkdir -p "$GITHUB_WORKSPACE/$UPLOAD_DIR"

# 仅在 NAME_SUFFIX 非空时执行重命名逻辑
if [ -n "$NAME_SUFFIX" ]; then
    echo "重命名文件..."
    find ./bin/targets/ -type f -name "*wrt*.img.gz" -exec sh -c '
        for f do
            base="${f%.img.gz}"
            mv "$f" "$GITHUB_WORKSPACE/$UPLOAD_DIR/${base}-${NAME_SUFFIX}.img.gz"
        done
    ' sh {} +
else
    echo "复制文件..."
    find ./bin/targets/ -type f -name "*wrt*.img.gz" -exec mv {} "$GITHUB_WORKSPACE/$UPLOAD_DIR/" \; 2>/dev/null
fi