#!/bin/bash

install_ready() {
	echo "开始配置免密登录（hadoop必须）！"
	##第一种办法(手动输入需要追加的主机-缺点手残输错就得重来)：
	#read -p "你想追加几台主机的hosts和hostname:" num
	#index=0
	#SERVERS=[]
	#while [ $index -lt $num ]
	#do 
	#	read -p "请添加需要配置的ip:" root_ip
	#	SERVERS[$index]=$root_ip
	#	let index++
	#done
	##第二种办法：
	SERVERS="10.0.4.5 10.0.4.3 10.0.4.15"
	PASSWORD=AA13760859526xxs
	
	for SERVER in $SERVERS
	do
		yum -y install expect
		# 批量创建文件夹
		echo 'no this dir and then will create it.'
		expect -c "set timeout -1;
			spawn ssh root@$SERVER mkdir -p /root/bin/ssh
		expect {
			*password:* {send -- $PASSWORD\r;exp_continue;}
			*(yes/no)* {send -- yes\r;exp_continue;}
			eof         {exit 0;}
		}"
		expect -c "set timeout -1;
			spawn scp ./ssh_non_pwd_login.sh $SERVER:/root/bin/ssh
		expect {
			*password:* {send -- $PASSWORD\r;exp_continue;}
			*(yes/no)* {send -- yes\r;exp_continue;}
			eof         {exit 0;}
		}"
		expect -c "set timeout -1;
			spawn ssh root@$SERVER /root/bin/ssh/ssh_non_pwd_login.sh
		expect {
			*password:* {send -- $PASSWORD\r;exp_continue;}
			*(yes/no)* {send -- yes\r;exp_continue;}
			eof         {exit 0;}
		}"
	done
	echo "配置免密登录完成！"
	echo "正在配置hostname和hosts"
	index=1
	for SERVER in ${SERVERS[*]}
	do
		#read -p "请设置用户${SERVER}的hostname:" root_hostname
		ssh root@$SERVER "hostnamectl set-hostname yixiao${index}"
		root_hostname=`ssh root@$SERVER hostname`
		root_ip=`ssh root@$SERVER ip addr |grep inet |grep -v inet6 |grep eth0|awk '{print $2}' |awk -F "/" '{print $1}'`
		echo "$root_ip	$root_hostname" >> /etc/hosts;
		let index++
	done
	for SERVER in ${SERVERS[*]}
	do
		scp -r /etc/hosts root@$SERVER:/etc/hosts
	done
	echo "配置hostname、hosts完成"
	echo "正在关闭防火墙！"
	for SERVER in ${SERVERS[*]}
	do
		ssh root@$SERVER "systemctl stop firewalld"
		ssh root@$SERVER "systemctl disable firewalld"
	done
	echo "已关闭防火墙！"
	echo "================================基础配置已全部完成================================="
}
install_ready
