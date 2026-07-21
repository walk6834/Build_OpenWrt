#!/bin/sh

CUSTOM_SETTINGS="files/etc/uci-defaults/99-custom-settings.sh"

set_password() {
	# 根据环境变量替换默认密码
	if [ -n "${ROOT_PASSWORD:-}" ]; then
		sed -i "s|^root_password=.*|root_password=\"${PASSWORD}\"|" "$CUSTOM_SETTINGS"
	fi
}

set_pppoe() {
	# 根据环境变量替换PPPoE账号密码（两者均存在时才替换）
	if [ -n "${PPPPOE_USERNAME:-}" ] && [ -n "${PPPPOE_PASSWORD:-}" ]; then
		sed -i "s|^pppoe_username=.*|pppoe_username=\"${PPPPOE_USERNAME}\"|" "$CUSTOM_SETTINGS"
		sed -i "s|^pppoe_password=.*|pppoe_password=\"${PPPPOE_PASSWORD}\"|" "$CUSTOM_SETTINGS"
	fi
}

# 方案二，修改默认LAN IP地址
set_ip_address() {
	# 根据环境变量替换默认LAN IP地址
	if [ -n "${IP_ADDRESS:-}" ]; then
		sed -i "s|^lan_ip_address=.*|lan_ip_address=\"${IP_ADDRESS}\"|" "$CUSTOM_SETTINGS"
	fi
}

# 主函数
main() {
	set_password
	set_pppoe
	# set_ip_address
}

# 调用主函数
main "$@"
