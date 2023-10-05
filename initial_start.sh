#!/bin/bash

# 启动./mcl程序
./mcl &

# 使用while循环来检测程序的标准输出
while true; do
    # 使用grep命令检查标准输出是否包含/bili文本
    if ./mcl | grep -q "/bili"; then
        echo 'stop' | ./mcl
        break
    fi
    sleep 1
done
