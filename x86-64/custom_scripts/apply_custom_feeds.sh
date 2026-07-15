#!/bin/sh

# 应用自定义Feeds
add_feed() {
    local feed_line="$1"

    # 已存在则跳过
    if grep -qF "$feed_line" feeds.conf.default; then
        echo "[跳过] 已存在: $feed_line"
        return
    fi

    echo "$feed_line" >> feeds.conf.default
    echo "[新增] $feed_line"
}

# 添加自定义Feeds
add_feed "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki;main"
add_feed "src-git momo https://github.com/nikkinikki-org/OpenWrt-momo;main"

# 更新&安装插件
./scripts/feeds update -a && ./scripts/feeds install -a
