#!/bin/sh

# 修改默认LAN口IP
uci set network.lan.ipaddr='192.168.10.1/24'

# 修改系统时区为东八区（上海）
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'

# 修改Web界面默认主题为 Argon
uci set luci.main.mediaurlbase='/luci-static/argon'

# 提交所有更改
uci commit

# 设置密码为 password
echo -ne "password\npassword" | passwd root

exit 0