#!/bin/sh

# 插入自定义Feeds
insert_feed() {
    local feed_line="$1"
    local insert_line="${2:-1}"

    # 已存在则跳过
    if grep -qF "$feed_line" feeds.conf.default; then
        echo "[跳过] 已存在: $feed_line"
        return
    fi

    sed -i "${insert_line}i $feed_line" feeds.conf.default
    echo "[新增] $feed_line"
}

# 追加自定义Feeds
append_feed() {
    local feed_line="$1"

    # 已存在则跳过
    if grep -qF "$feed_line" feeds.conf.default; then
        echo "[跳过] 已存在: $feed_line"
        return
    fi

    sed -i "$a $feed_line" feeds.conf.default
    echo "[新增] $feed_line"
}

# 更新&安装插件
update_install_feeds() {
    ./scripts/feeds update -a 1>/dev/null 2>&1
    ./scripts/feeds install -a 1>/dev/null 2>&1
}

# 主函数
main() {
    # 添加自定义Feeds
    insert_feed "src-git small https://github.com/kenzok8/small;main"

    # 删除冲突的插件
    rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb}

    # 更新&安装插件
    update_install_feeds
}

# 调用主函数
main "$@"

