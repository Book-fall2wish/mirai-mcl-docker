#!/usr/bin/expect -f

# 启动程序
spawn /home/mirai/mcl -u

# 等待程序准备就绪
expect "重连次数耗尽"

# 发送升级命令
send "stop\r"

# 等待程序退出
expect eof