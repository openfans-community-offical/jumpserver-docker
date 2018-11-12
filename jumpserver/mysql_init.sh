#!/bin/bash

set -ex

mkdir -p /var/run/mysqld 2>/dev/null
chown mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql
mysqld_safe &

sleep 5s

mysql -uroot -e "
create database jumpserver default charset 'utf8';
grant all on jumpserver.* to 'jumpserver'@'127.0.0.1' identified by 'P@ssword01!@jumpServer';
flush privileges;"

exit 0
