#!/bin/sh

CUSTOM_SETTINGS="files/etc/uci-defaults/99-custom-settings.sh"

# 设置固件rootfs大小
if [ -n "${PART_SIZE:-}" ]; then
    sed -i '/ROOTFS_PARTSIZE/d' .config
    echo "CONFIG_TARGET_ROOTFS_PARTSIZE=$PART_SIZE" >> .config
fi

# 根据环境变量替换默认密码
if [ -n "${PASSWORD:-}" ]; then
    sed -i "s|^root_password=.*|root_password=\"${PASSWORD}\"|" "$CUSTOM_SETTINGS"
fi

# 根据环境变量替换默认LAN IP地址
if [ -n "${IP_ADDRESS:-}" ]; then
    sed -i "s|^lan_ip_address=.*|lan_ip_address=\"${IP_ADDRESS}\"|" "$CUSTOM_SETTINGS"
fi

# 更改argon主题背景
BG_SRC="$GITHUB_WORKSPACE/images/bg1.jpg"
BG_DST="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg"
if [ -f "$BG_SRC" ]; then
    cp -f "$BG_SRC" "$BG_DST" && echo "已替换 Argon 主题背景" || echo "Argon 主题背景替换失败"
else
    echo "未找到 Argon 主题背景文件，跳过"
fi