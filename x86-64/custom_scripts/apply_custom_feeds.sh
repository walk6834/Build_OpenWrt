#!/bin/sh

# 插入自定义Feeds
add_feed() {
    local feed_line="$1"
    local insert_line="${2:-\$a}"

    # 已存在则跳过
    if grep -qF "$feed_line" feeds.conf.default; then
        echo "[跳过] 已存在: $feed_line"
        return
    fi

    sed -i "${insert_line} $feed_line" feeds.conf.default
    echo "[新增] $feed_line"
}

# 更新&安装插件
update_install_feeds() {
    echo "更新feeds..."
    ./scripts/feeds update -a

    echo "删除冲突的插件..."
    rm -rf feeds/luci/applications/luci-app-mosdns
    rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,sing*,smartdns} feeds/packages/utils/v2dat feeds/packages/lang/golang

    echo "安装golang..."
    rm -rf feeds/packages/lang/golang
    git clone https://github.com/kenzok8/golang -b 1.26 feeds/packages/lang/golang
    
    echo "安装feeds..."
    ./scripts/feeds install -a
}

# 主函数
main() {
    # 添加自定义Feeds
    add_feed "src-git kenzo https://github.com/kenzok8/openwrt-packages" '1i'
    add_feed "src-git small https://github.com/kenzok8/small" '2i'

    # 更新&安装插件
    update_install_feeds
}

# 调用主函数
main "$@"

