#!/bin/sh

# 记录所有操作到 /tmp/setup.log
#exec >/tmp/setup.log 2>&1

# 系统后台密码（为空则不修改）
root_password="password"

# LAN 的 IPv4 地址
# lan_ip_address="192.168.10.1"

# 修改root 密码
if [ -n "$root_password" ]; then
    (echo "$root_password"; sleep 1; echo "$root_password") | passwd root >/dev/null
fi

# # 修改默认LAN口IP
# if [ -n "$lan_ip_address" ]; then
#     uci set network.lan.ipaddr="$lan_ip_address/24"
# fi

# 修改系统时区为东八区（上海）
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'

# 修改Web界面默认主题为 Argon
uci set luci.main.mediaurlbase='/luci-static/argon'

# 提交所有更改
uci commit

exit 0