#!/bin/sh

[ -e "$GITHUB_WORKSPACE/files" ] && mv "$GITHUB_WORKSPACE/files" files

# 设置固件rootfs大小
if [ -n "${PART_SIZE:-}" ]; then
    sed -i '/ROOTFS_PARTSIZE/d' .config
    echo "CONFIG_TARGET_ROOTFS_PARTSIZE=$PART_SIZE" >> .config
fi

# 修改默认ip地址
[ -n "${IP_ADDRESS:-}" ] && sed -i '/lan) ipad/s/".*"/"'"$IP_ADDRESS"'"/' package/base-files/files/bin/config_generate

# ttyd免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 设置root用户密码为password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# 更改argon主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg