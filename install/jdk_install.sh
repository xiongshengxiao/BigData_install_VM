#! /bin/bash

install_jdk() {
	echo "批量创建文件夹"
	index=3
	for ((i=1; i<=index; i++))
	do
		ssh yixiao${i} "mkdir -p /export/server/"
		ssh yixiao${i} "mkdir -p /export/software/"
	done
	echo "文件夹全部创建完成"
	
	echo "开始安装jdk"
	echo "开始下载jdk"
	if [[ ! -f /export/software/jdk-8u202-linux-x64.tar.gz ]]; then
	wget --no-check-certificate -P /export/software https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
	echo "下载jdk完成"
	else
	echo "jdk安装包已存在"
	fi
	
	echo "开始解压jdk"
	tar -zxf /export/software/jdk-8u202-linux-x64.tar.gz -C /export/server/
	echo "解压jdk完成"
	echo "开始添加jdk环境变量"
	ipath="/export/server/"
	sed -i '$a\JAVA_HOME=/export/server/jdk1.8.0_202\n\CLASSPATH=.:$JAVA_HOME/lib\n\PATH=$JAVA_HOME/bin:$PATH\n\export JAVA_HOME CLASSPATH PATH' /etc/profile
	echo "开始分发jdk"
	for ((i=2; i<=index; i++))
	do
		scp -r /export/server/jdk1.8.0_202 root@yixiao${i}:/export/server/
		scp -r /etc/profile root@yixiao${i}:/etc/
	done
	for ((i=1; i<=index; i++))
	do
		ssh yixiao${i} "source /etc/profile"
	done
	echo "jdk全部安装成功"
}
install_jdk
