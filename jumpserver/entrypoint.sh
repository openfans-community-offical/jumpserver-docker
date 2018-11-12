#!/bin/bash
#

echo 2048 > /proc/sys/net/core/somaxconn
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 1 > /proc/sys/vm/overcommit_memory 
sysctl -w net.core.somaxconn=32768 

export LANG=zh_CN.UTF-8

#make ssl crt
if [ ! -f /opt/sslcrt/cecos.crt ] || [ ! -f /opt/sslcrt/cecos.key ]; then
	echo -e "\n Set SSL cert and key file ... \n"
	rm -rf /opt/sslcrt/cecos.crt ; rm -rf /opt/sslcrt/cecos.key
	openssl genrsa -out /opt/sslcrt/cecos.key 4096
	openssl ecparam -genkey -name secp384r1 -out /opt/sslcrt/cecos.key
	openssl req -new -x509 -sha256 -key /opt/sslcrt/cecos.key -out /opt/sslcrt/cecos.crt -days 36500 \
	-subj "/C=$VARC/ST=$VARST/L=$VARL/O=$VARO/OU=$VAROU/CN=$VARCN/emailAddress=$VARMAIL"
	openssl x509 -in /opt/sslcrt/cecos.crt -noout -text | /bin/grep 'Issuer:'
	echo -e "\n SSL cert and key file set done. \n\n"
else
	echo -e "\n SSL cert and key file found, skip. \n\n"
fi
#make ssl crt end

if [ $DB_HOST == 127.0.0.1 ]; then
rm -rf /var/run/mysqld/mysqld.sock.lock 2>/dev/null
mkdir -p /var/run/mysqld 2>/dev/null
chown mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql
mysqld_safe &
sleep 5
fi

if [ $REDIS_HOST == 127.0.0.1 ]; then
redis-server &
sleep 3
fi

python3.6 -m venv /opt/py3 && . /opt/py3/bin/activate

function make_migrations(){
    cd /opt/jumpserver/utils
    bash make_migrations.sh
}

function make_migrations_if_need(){
    sentinel=/opt/jumpserver/data/inited

    if [ -f ${sentinel} ];then
        echo "Database have been inited."
    else
        make_migrations && echo "Database init success" && touch $sentinel
    fi
}

function start() {
    make_migrations_if_need
}

case $1 in
    init) make_migrations;;
    *) start;;
esac

cd /opt/jumpserver && ./jms start all -d
/usr/sbin/nginx &
/etc/init.d/guacd start
cat /opt/note.txt
cd /config/tomcat8/bin && ./startup.sh
cd /opt/coco && ./cocod start -d
cd /opt && tail -f /opt/readme.txt
