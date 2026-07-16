#!/bin/sh

CONFIG_FILE=".config"
CUSTOM_SETTINGS="files/etc/uci-defaults/99-custom-settings.sh"
CONFIG_GENERATE="package/base-files/files/bin/config_generate"

# 设置固件rootfs大小
if [ -n "${PART_SIZE:-}" ]; then
    sed -i '/ROOTFS_PARTSIZE/d' "$CONFIG_FILE"
    echo "CONFIG_TARGET_ROOTFS_PARTSIZE=$PART_SIZE" >> "$CONFIG_FILE"
fi

# 根据环境变量替换默认密码
if [ -n "${ROOT_PASSWORD:-}" ]; then
    sed -i "s|^root_password=.*|root_password=\"${PASSWORD}\"|" "$CUSTOM_SETTINGS"
fi

# 根据环境变量替换PPPoE账号密码（两者均存在时才替换）
if [ -n "${PPPPOE_USERNAME:-}" ] && [ -n "${PPPPOE_PASSWORD:-}" ]; then
    sed -i "s|^pppoe_username=.*|pppoe_username=\"${PPPPOE_USERNAME}\"|" "$CUSTOM_SETTINGS"
    sed -i "s|^pppoe_password=.*|pppoe_password=\"${PPPPOE_PASSWORD}\"|" "$CUSTOM_SETTINGS"
fi

# 方案一
# 根据环境变量替换默认LAN IP地址
if [ -n "${IP_ADDRESS:-}" ]; then
    sed -i '/lan) ipad/s/".*"/"'"$IP_ADDRESS"'"/' "$CONFIG_GENERATE"
fi

# 方案二
# 根据环境变量替换默认LAN IP地址
# if [ -n "${IP_ADDRESS:-}" ]; then
#     sed -i "s|^lan_ip_address=.*|lan_ip_address=\"${IP_ADDRESS}\"|" "$CUSTOM_SETTINGS"
# fi

# 更改argon主题背景
BG_SRC="$GITHUB_WORKSPACE/images/bg1.jpg"
BG_DST="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg"
if [ -f "$BG_SRC" ]; then
    cp -f "$BG_SRC" "$BG_DST" && echo "已替换 Argon 主题背景" || echo "Argon 主题背景替换失败"
fi

# ttyd免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config