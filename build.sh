#!/bin/sh

OPENWRT_REPO=immortalwrt/immortalwrt
OPENWRT_BRANCH=openwrt-25.12
OPENWRT_DIR=openwrt
TARGET_ARCH=x86-64

export PART_SIZE=1024
export GITHUB_WORKSPACE=$(pwd)
export UPLOAD_DIR=uploads

echo "开始克隆OpenWrt仓库..."
git clone -b $OPENWRT_BRANCH --single-branch --depth 1 https://github.com/$OPENWRT_REPO.git $OPENWRT_DIR

echo "复制文件..."
cp -r ./$TARGET_ARCH/* $OPENWRT_DIR/

echo "设置文件权限..."
chmod +x $OPENWRT_DIR/files/etc/uci-defaults/*.sh
chmod +x $OPENWRT_DIR/custom_scripts/*.sh

echo "切换到OpenWrt目录..."
cd $OPENWRT_DIR

echo "更新feeds并安装..."
./custom_scripts/apply_custom_feeds.sh

echo "生辰默认配置..."
cp -f default.config .config
make defconfig

echo "应用自定义设置..."
./custom_scripts/apply_custom_settings.sh

echo "开始下载依赖..."
make download -j $(($(nproc)+1)) V=s

echo "开始编译OpenWrt..."
echo $(date "+%Y-%m-%d %H:%M:%S start") > build.txt
make -j $(($(nproc)+1)) V=s || make -j1 V=s
echo $(date "+%Y-%m-%d %H:%M:%S end") >> build.txt

echo "开始上传..."
./custom_scripts/collect_upload.sh

echo "全部完成"