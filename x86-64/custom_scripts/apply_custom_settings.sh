#!/bin/sh

# 设置固件rootfs大小
if [ -n "${PART_SIZE:-}" ]; then
    sed -i '/ROOTFS_PARTSIZE/d' .config
    echo "CONFIG_TARGET_ROOTFS_PARTSIZE=$PART_SIZE" >> .config
fi

# 更改argon主题背景
# cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg