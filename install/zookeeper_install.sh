#! /bin/bash

install_zookeeper() {
	echo "开始安装zookeeper"
	echo "开始下载zookeeper"
	
	if [[ ! -f /export/software/apache-zookeeper-3.5.9-bin.tar.gz ]]; then
	wget --no-check-certificate -P /export/software https://repo.huaweicloud.com/apache/zookeeper/zookeeper-3.5.9/apache-zookeeper-3.5.9-bin.tar.gz
	echo "zookeeper下载完成"
	else
	echo "zookeeper安装包已存在"
	fi
	
	tar -zxf /export/software/apache-zookeeper-3.5.9-bin.tar.gz -C /export/server/
	mv /export/server/apache-zookeeper-3.5.9-bin /export/server/zookeeper
	mkdir -p /export/server/zookeeper/zkdata
	mkdir -p /export/server/zookeeper/zkdatalog
	cp /export/server/zookeeper/conf/zoo_sample.cfg /export/server/zookeeper/conf/zoo.cfg
	sed -i 's|/tmp/zookeeper|/export/server/zookeeper/zkdata|g' /export/server/zookeeper/conf/zoo.cfg
	echo 'dataLogDir=/export/server/zookeeper/zkdatalog' >> /export/server/zookeeper/conf/zoo.cfg
	index=3
	for ((i=1; i<=index; i++))
	do
		echo "server.${i}=yixiao${i}:2888:3888" >> /export/server/zookeeper/conf/zoo.cfg
	done
	for ((i=2; i<=index;i++))
	do
		scp -r /export/server/zookeeper root@yixiao${i}:/export/server/
		ssh root@yixiao${i} "mkdir -p /export/server/zookeeper/zkdata"
		ssh root@yixiao${i} "mkdir -p /export/server/zookeeper/zkdatalog"
		ssh root@yixiao${i} "echo ${i} >> /export/server/zookeeper/zkdata/myid"
	done 
	echo '1' > /export/server/zookeeper/zkdata/myid
	echo "==================zookeeper安装完成，请查看是否安装成功====================="
}
install_zookeeper
