#!/bin/bash

install_hive() {
	echo "开始安装Hive"
	echo "开始下载Hive"
	
	if [[ ! -f /export/software/apache-hive-3.1.2-bin.tar.gz ]]; then
	wget --no-check-certificate -P /export/software/ https://repo.huaweicloud.com/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
	echo "Hive下载完成"
	else
	echo "Hive安装包已存在"
	fi
	
	echo "开始解压Hive"
	tar -zxf /export/software/apache-hive-3.1.2-bin.tar.gz -C /export/server/
	mv /export/server/apache-hive-3.1.2-bin /export/server/hive-3.1.2
	rm -rf /export/server/hive-3.1.2/lib/guava-19.0.jar
	cp /export/server/hadoop-3.3.0/share/hadoop/common/lib/guava-27.0-jre.jar /export/server/hive-3.1.2/lib
	#wget -P /export/server/hive-3.1.2/conf http://suhang.work/hadoop_etc/hive-env.sh
	#wget -P /export/server/hive-3.1.2/conf http://suhang.work/hadoop_etc/hive-site.xml
	#wget -P /export/server/hive-3.1.2/lib http://suhang.work/hadoop_etc/mysql-connector-java-5.1.32.jar
	cp -r /root/script/file/Hive/hive-env.sh /export/server/hive-3.1.2/conf/
	cp -r /root/script/file/Hive/hive-site.xml /export/server/hive-3.1.2/conf/
	cp -r /root/script/file/Hive/mysql-connector-java-5.1.32.jar /export/server/hive-3.1.2/lib/
	echo "开始初始化hive"
	/export/server/hive-3.1.2/bin/schematool -initSchema -dbType mysql -verbos
	/export/server/hadoop-3.3.0/bin/hadoop fs -mkdir /tmp
	/export/server/hadoop-3.3.0/bin/hadoop fs -mkdir -p /user/hive/warehouse
	/export/server/hadoop-3.3.0/bin/hadoop fs -chmod g+w /tmp
	/export/server/hadoop-3.3.0/bin/hadoop fs -chmod g+w /user/hive/warehouse

	if [[ -d /export/server/hive-3.1.2 ]]; then
	echo "hive已安装"
	hive_install=true;
	else
	echo -e "hive安装失败"
	hive_install=false;
	fi
}
install_hive
