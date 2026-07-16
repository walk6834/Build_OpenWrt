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

# 更新&安装插件
update_install_feeds() {
    ./scripts/feeds update -a 1>/dev/null 2>&1
    ./scripts/feeds install -a 1>/dev/null 2>&1
}

# 主函数
main() {
    # 添加自定义Feeds
    add_feed "src-git small https://github.com/kenzok8/small;main"

    # 更新&安装插件
    update_install_feeds
}

# 调用主函数
main "$@"

