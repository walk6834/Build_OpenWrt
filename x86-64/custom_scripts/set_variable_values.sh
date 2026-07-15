#!/bin/sh

# 源仓库与分支
SOURCE_REPO=$(basename "$OPENWRT_REPO")
echo "SOURCE_REPO=$SOURCE_REPO" >> $GITHUB_ENV
echo "LITE_BRANCH=${OPENWRT_BRANCH#*-}" >> $GITHUB_ENV

# 平台架构
TARGET_NAME=$(grep -oP "^CONFIG_TARGET_\K[a-z0-9]+(?==y)" .config)
SUBTARGET_NAME=$(grep -oP "^CONFIG_TARGET_${TARGET_NAME}_\K[a-z0-9]+(?==y)" .config)
DEVICE_TARGET="$TARGET_NAME-$SUBTARGET_NAME"
echo "TARGET_NAME=$TARGET_NAME" >> $GITHUB_ENV
echo "SUBTARGET_NAME=$SUBTARGET_NAME" >> $GITHUB_ENV
echo "DEVICE_TARGET=$DEVICE_TARGET" >> $GITHUB_ENV

# 内核版本
KERNEL=$(grep -oP 'KERNEL_PATCHVER:=\K[\d\.]+' "target/linux/$TARGET_NAME/Makefile")
KERNEL_FILE="include/kernel-$KERNEL"
[ -e "$KERNEL_FILE" ] || KERNEL_FILE="target/linux/generic/kernel-$KERNEL"
KERNEL_VERSION=$(grep -oP 'LINUX_KERNEL_HASH-\K[\d\.]+' "$KERNEL_FILE")
echo "KERNEL_VERSION=$KERNEL_VERSION" >> $GITHUB_ENV

# 源码更新信息
echo "COMMIT_AUTHOR=$(git show -s --date=short --format="作者: %an")" >> $GITHUB_ENV
echo "COMMIT_DATE=$(git show -s --date=short --format="时间: %ci")" >> $GITHUB_ENV
echo "COMMIT_MESSAGE=$(git show -s --date=short --format="内容: %s")" >> $GITHUB_ENV
echo "COMMIT_HASH=$(git show -s --date=short --format="hash: %H")" >> $GITHUB_ENV