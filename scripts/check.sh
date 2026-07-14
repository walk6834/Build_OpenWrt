#!/bin/sh

echo "==========================CPU信息=========================="
echo "CPU物理数量: $(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)"
echo "CPU线程数量: $(nproc)"
echo "CPU型号信息:$(cat /proc/cpuinfo | grep -m1 name | awk -F: '{print $2}')\n"
echo "==========================内存信息=========================="
echo "已安装内存详细信息:"
echo "$(sudo lshw -short -C memory | grep GiB)\n"
echo "==========================硬盘信息=========================="
echo "硬盘数量: $(ls /dev/sd* | grep -v [1-9] | wc -l)"
echo "使用情况:"
df -hT
echo "=============================================================================="
