#!/bin/bash -x
set -e

cmd="/usr/local/mysql/bin/mysqld_safe  --user=mysql --datadir=/usr/local/mysql/data"

if [ ! -d '/usr/local/mysql/data' ]; then
	_mysql_password="root"
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		echo 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
		echo 'Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
	fi

	cp -r /usr/local/mysql/data_dump/* /usr/local/mysql/data/
	chown -R mysql.mysql /usr/local/mysql/data/

	/mysql-setup.sh

    TEMP_FILE='/opt/mysql-first-time.sql'
	$($cmd "--init-file=$TEMP_FILE")
else
	$($cmd)
fi
