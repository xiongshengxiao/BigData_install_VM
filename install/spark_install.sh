install_spark() {
	echo "开始安装spark"
	echo "开始下载spark"
	if [[ ! -f /export/software/spark-3.1.2-bin-hadoop3.2.tgz ]]; then
	wget --no-check-certificate -P /export/software/ https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
	echo "spark下载完成"
	else
	echo "spark安装包已存在"
	fi
	echo "开始解压spark"
	tar -zxf /export/software/spark-3.1.2-bin-hadoop3.2.tgz -C /export/server/
	mv /export/server/spark-3.1.2-bin-hadoop3.2 /export/server/spark
	echo "开始修改spark配置文件"
	cp /export/server/spark/conf/workers.template /export/server/spark/conf/workers
	cp /export/server/spark/conf/spark-env.sh.template /export/server/spark/conf/spark-env.sh
	cp /export/server/spark/conf/spark-defaults.conf.template /export/server/spark/conf/spark-defaults.conf
	cp /export/server/spark/conf/log4j.properties.template /export/server/spark/conf/log4j.properties
	sed -i 's/localhost/yixiao1\nyixiao2\nyixiao3/' /export/server/spark/conf/workers
	sed -i '$a\spark.eventLog.enabled true\n\spark.eventLog.dir hdfs://yixiao1:8020/sparklog/\n\spark.eventLog.compress true\n\spark.yarn.historyServer.address yixiao1:18080\n\spark.yarn.jars  hdfs://yixiao1:8020/spark/jars/*' /export/server/spark/conf/spark-defaults.conf
	sed -i 's/log4j.rootCategory=INFO/log4j.rootCategory=WARN/' /export/server/spark/conf/log4j.properties.template
	cp /root/script/file/spark/spark-env.sh /export/server/spark/conf/
	cp /export/server/hive-3.1.2/lib/mysql-connector-java-5.1.32.jar /export/server/spark/jars
	cp /export/server/hive-3.1.2/conf/hive-site.xml /export/server/spark/conf
	echo "开始分发Spark"
	index=3
	for ((i=2; i<=index; i++))
	do
		scp -r /export/server/spark root@yixiao${i}:/export/server/
	done
	echo "此处会卡一会儿，属于正常情况，请耐心等待"
	/export/server/hadoop-3.3.0/bin/hadoop fs -mkdir -p /spark/jars/
	/export/server/hadoop-3.3.0/bin/hadoop fs -put /export/server/spark/jars/* /spark/jars/
	/export/server/hadoop-3.3.0/bin/hadoop fs -mkdir -p /sparklog
	echo "开始下载anaconda3"
	wget --no-check-certificate -P /export/software/ https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2021.05-Linux-x86_64.sh
	echo "分发anaconda3安装包"
	for ((i=2; i<=index; i++))
	do
		scp -r /export/software/Anaconda3-2021.05-Linux-x86_64.sh root@yixiao${i}:/export/software/
	done
	echo "开始安装anaconda3"
	for ((i=1; i<=index; i++))
	do
		ssh root@yixiao${i} "sh /export/software/Anaconda3-2021.05-Linux-x86_64.sh -b"
	done
	echo "开始添加环境变量"
	sed -i '$a\export ANACONDA_HOME=/root/anaconda3/bin \n\export PATH=$PATH:$ANACONDA_HOME/bin' /etc/profile
	for ((i=2; i<=index; i++))
	do
		scp -r /etc/profile root@yixiao${i}:/etc/
	done
	for ((i=1; i<=index; i++))
	do
		ssh root@yixiao${i} "source /etc/profile"
		ssh root@yixiao${i} "sed -i '1a\export PATH=~/anaconda3/bin:$PATH' /root/.bashrc"
		ssh root@yixiao${i} "/root/anaconda3/bin/pip install pyspark"
		ssh root@yixiao${i} "/root/anaconda3/bin/pip install pyspark[sql]"
	done
	if [[ -d /export/server/spark ]]; then
	echo "spark已安装"
	spark_install=true;
	else
	echo -e "spark安装失败"
	spark_install=false;
	fi
}
install_spark