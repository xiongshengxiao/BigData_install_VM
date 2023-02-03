# !/bin/bash

#read -p "你想追加几台主机的hosts和hostname:" num
#index=0
#SERVERS=[]
#while [ $index -lt $num ]
#do 
#	read -p "请添加需要配置的ip:" root_ip
#	SERVERS[$index]=$root_ip
#	let index++
#done
SERVERS="10.0.4.5 10.0.4.3 10.0.4.15"
PASSWORD=AA13760859526xxs

auto_gen_ssh_key() {
    expect -c "set timeout -1;
    	spawn ssh-keygen;
	expect {
	    *(/root/.ssh/id_rsa)* {send -- \r;exp_continue;}
		*passphrase)* {send -- \r;exp_continue;}
		*again*	{send -- \r;exp_continue;}
		*(y/n)* {send -- y\r;exp_continue;}
		*password:* {send -- $PASSWORD\r;exp_continue;}
		eof         {exit 0;}
	}";
}

auto_ssh_copy_id() {
	expect -c "set timeout -1;
    	spawn ssh-copy-id $1;
	expect {
	    *(yes/no)*  {send -- yes\r;exp_continue;}
	    *password:* {send -- $2\r;exp_continue;}
	    eof         {exit 0;}
	}";
}

auto_copy_id_to_all() {
	for SERVER in $SERVERS
    do
         auto_ssh_copy_id $SERVER $PASSWORD
    done
}
yum -y install expect
auto_gen_ssh_key
auto_copy_id_to_all