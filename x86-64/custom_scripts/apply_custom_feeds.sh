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

    sed -i "\$a $feed_line" feeds.conf.default
    echo "[新增] $feed_line"
}

# 更新&安装插件
update_install_feeds() {
    echo "更新feeds..."
    ./scripts/feeds update -a

    echo "删除冲突的插件..."
    rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb}

    echo "删除报错的插件..."
    rm -rf feeds/smpackage/{webd}
    
    echo "安装feeds..."
    ./scripts/feeds install -a
}

# 主函数
main() {
    # 添加自定义Feeds
    append_feed "src-git smpackage https://github.com/kenzok8/small-package;main"

    # 更新&安装插件
    update_install_feeds
}

# 调用主函数
main "$@"

