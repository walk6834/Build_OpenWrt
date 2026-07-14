#!/bin/sh

OPENWRT_BRANCH=openwrt-25.12
OPENWRT_REPO=immortalwrt/immortalwrt
OPENWRT_DIR=immortalwrt
TARGET_ARCH=x86_64

echo "切换到OpenWrt目录..."
cd $OPENWRT_DIR

echo "清理旧构建..."
make distclean

echo "当前feeds配置:"
cat feeds.conf.default

echo "更新feeds并安装..."
./scripts/feeds update -a && ./scripts/feeds install -a

echo "复制默认配置..."
cp default.config .config
make defconfig

echo "开始下载依赖..."
make download -j $(($(nproc)+1)) V=s

echo "开始编译OpenWrt..."
echo $(date "+%Y-%m-%d %H:%M:%S start") > build.txt
make -j $(($(nproc)+1)) V=s || make -j1 V=s
echo $(date "+%Y-%m-%d %H:%M:%S end") >> build.txt
echo "OpenWrt编译完成"