#!/bin/bash
# 1 数组 放 主机名
hosts=(yixiao1 yixiao2 yixiao3)
# 2 遍历 关闭
for host in ${hosts[*]}
do
ssh $host "source /etc/profile;/export/server/zookeeper/bin/zkServer.sh start"
done
