#!/bin/sh

OPENWRT_REPO=immortalwrt/immortalwrt
OPENWRT_BRANCH=openwrt-25.12
OPENWRT_DIR=immortalwrt
TARGET_ARCH=x86-64


echo "开始克隆OpenWrt仓库..."
git clone -b $OPENWRT_BRANCH --single-branch --depth 1 https://github.com/$OPENWRT_REPO.git $OPENWRT_DIR

echo "复制文件..."
cp -r ./$TARGET_ARCH/* $OPENWRT_DIR

echo "设置文件权限..."
chmod +x $OPENWRT_DIR/files/etc/uci-defaults/*.sh

echo "切换到OpenWrt目录..."
cd $OPENWRT_DIR

echo "当前feeds配置:"
cat feeds.conf.default

echo "开始添加feeds..."
echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki;main' >> feeds.conf.default
echo 'src-git momo https://github.com/nikkinikki-org/OpenWrt-momo;main' >> feeds.conf.default

echo "校验feeds："
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