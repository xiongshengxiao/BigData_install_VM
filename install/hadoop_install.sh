#!/bin/bash

install_hadoop() {
	echo "开始安装hadoop"
	echo "开始下载hadoop"
	
	if [[ ! -f /export/software/hadoop-3.3.0.tar.gz ]]; then
	wget --no-check-certificate -P /export/software https://repo.huaweicloud.com/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
	echo "hadoop下载完成"
	else
	echo "hadoop安装包已存在"
	fi
	
	
	echo "开始解压hadoop"
	tar -zxf /export/software/hadoop-3.3.0.tar.gz -C /export/server/
	echo "hadoop解压完成"
	echo "开始修改配置文件"
	sed -i '$a\export JAVA_HOME=/export/server/jdk1.8.0_202\n\export HDFS_NAMENODE_USER=root\n\export HDFS_DATANODE_USER=root\n\export HDFS_SECONDARYNAMENODE_USER=root\n\export YARN_RESOURCEMANAGER_USER=root\n\export YARN_NODEMANAGER_USER=root' /export/server/hadoop-3.3.0/etc/hadoop/hadoop-env.sh
	mv /export/server/hadoop-3.3.0/etc/hadoop/core-site.xml.bak /export/server/hadoop-3.3.0/etc/hadoop/core-site.xml
	mv /export/server/hadoop-3.3.0/etc/hadoop/hdfs-site.xml.bak /export/server/hadoop-3.3.0/etc/hadoop/hdfs-site.xml
	mv /export/server/hadoop-3.3.0/etc/hadoop/mapred-site.xml.bak /export/server/hadoop-3.3.0/etc/hadoop/mapred-site.xml 
	mv /export/server/hadoop-3.3.0/etc/hadoop/yarn-site.xml.bak /export/server/hadoop-3.3.0/etc/hadoop/yarn-site.xml
	mv /export/server/hadoop-3.3.0/etc/hadoop/workers.bak /export/server/hadoop-3.3.0/etc/hadoop/workers

	cp -r /root/script/file/Hadoop/* /export/server/hadoop-3.3.0/etc/hadoop/
	echo "hadoop修改配置文件完成"
	echo "开始添加环境变量"
	sed -i '$a\export HADOOP_HOME=/export/server/hadoop-3.3.0\n\export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' /etc/profile
	index=3
	for ((i=2; i<=index; i++))
	do
		scp -r /export/server/hadoop-3.3.0 root@yixiao${i}:/export/server/
		scp -r /etc/profile root@yixiao${i}:/etc/
	done
	for ((i=1; i<=index; i++))
	do
		ssh root@yixiao${i} "source /etc/profile"
	done
	#hdfs namenode -format
	#echo "格式化namenode完成"
	echo "重启请执行hdfs namenode -format对Hadoop（主节点）格式化"
	echo "==================Hadoop安装完成=================="
}
install_hadoop
