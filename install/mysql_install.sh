#!/bin/bash

install_mysql() {
	mysql_passwd='yixiao666'
	echo "开始安装mysql"
	mariadb=`rpm -qa|grep mariadb`
	rpm -e $mariadb --nodeps
	mkdir /export/software/mysql
	echo "开始下载mysql"
	
	if [[ ! -f /export/software/mysql/mysql-5.7.34-1.el7.x86_64.rpm-bundle.tar ]]; then
	wget --no-check-certificate -P /export/software/mysql https://repo.huaweicloud.com/mysql/Downloads/MySQL-5.7/mysql-5.7.34-1.el7.x86_64.rpm-bundle.tar
	echo "mysql下载完成"
	else
	echo "mysql安装包已存在"
	fi
	
	cd /export/software/mysql
	echo "开始解压mysql"
	tar -xvf /export/software/mysql/mysql-5.7.34-1.el7.x86_64.rpm-bundle.tar -C /export/software/mysql
	echo "解压完成"
	yum -y install libaio
	yum -y install numactl
	rpm -ivh mysql-community-common-5.7.34-1.el7.x86_64.rpm mysql-community-libs-5.7.34-1.el7.x86_64.rpm mysql-community-client-5.7.34-1.el7.x86_64.rpm mysql-community-server-5.7.34-1.el7.x86_64.rpm 
	echo "初始化mysql"
	mysqld --initialize
	chown mysql:mysql /var/lib/mysql -R
	systemctl start mysqld.service
	tmp_passwd=`grep 'temporary password' /var/log/mysqld.log | awk '{print $11}'`
	mysql --connect-expired-password -uroot -p$tmp_passwd << EOF
	alter user user() identified by "yixiao666";
	use mysql;
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'yixiao666' WITH GRANT OPTION;
	FLUSH PRIVILEGES;
	exit
EOF
	echo "mysql开机启动"
	systemctl enable  mysqld
	mysql_tmp=`systemctl status mysqld.service | grep active`
	if [[ $mysql_tmp ]]; then
	echo "mysql已安装"
	mysql_install=true;
	else
	echo -e "mysql安装失败"
	mysql_install=false;
	fi
	cd
}
install_mysql
