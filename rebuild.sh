#!/bin/sh

OPENWRT_BRANCH=openwrt-25.12
OPENWRT_REPO=immortalwrt/immortalwrt
OPENWRT_DIR=immortalwrt
TARGET_ARCH=x86_64

export PART_SIZE=1024
export GITHUB_WORKSPACE=$(pwd)
export UPLOAD_DIR=uploads

echo "切换到OpenWrt目录..."
cd $OPENWRT_DIR

echo "清理旧构建..."
make clean                    # 清理编译产物
# make dirclean                 # 清理更彻底（包括工具链）
# make distclean                # 完全清理（需重新配置）
rm -rf $UPLOAD_DIR/

echo "切换到OpenWrt目录..."
cd $OPENWRT_DIR

echo "更新feeds并安装..."
./custom_scripts/apply_custom_feeds.sh

echo "生辰默认配置..."
cp default.config .config
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