#!/bin/sh

# 查找目录
find_dir() {
	dir="$1"
	name="$2"
	find "$dir" -maxdepth 3 -type d -name "$name" -print -quit 2>/dev/null
}

# 插入自定义Feeds
add_feed() {
	feed_line="$1"
	insert_line="${2:-\$a}"

	# 已存在则跳过
	if grep -qF "$feed_line" feeds.conf.default; then
		echo "[跳过] 已存在: $feed_line"
		return
	fi

	sed -i "${insert_line} $feed_line" feeds.conf.default
	echo "[新增] $feed_line"
}

# 更新&安装插件
update_feeds() {
	echo "更新feeds..."
	./scripts/feeds update -a
}

# 更新&安装插件
install_feeds() {
	echo "安装feeds..."
	./scripts/feeds install -a
}

# 添加自定义Feeds
add_custom_feeds() {
	add_feed "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" '1i'
	add_feed "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" '2i'
	add_feed "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main"
	add_feed "src-git momo https://github.com/nikkinikki-org/OpenWrt-momo.git;main"

	update_feeds
	install_feeds
}

# 添加自定义Feeds
add_custom_feeds1() {
	# 添加自定义Feeds
	add_feed "src-git kenzo https://github.com/kenzok8/openwrt-packages" '1i'
	add_feed "src-git small https://github.com/kenzok8/small" '2i'

	update_feeds

	echo "删除冲突的插件..."
	rm -rf feeds/luci/applications/luci-app-mosdns
	rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns} feeds/packages/utils/v2dat feeds/packages/lang/golang

	echo "安装golang..."
	rm -rf feeds/packages/lang/golang
	git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang

	install_feeds
}

# 主函数
main() {
	# 添加自定义Feeds
	add_custom_feeds
}

# 调用主函数
main "$@"
