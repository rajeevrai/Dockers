#!/bin/bash -x
set -e

cmd="/usr/local/mysql/bin/mysqld --user=mysql --datadir=/usr/local/mysql/data/"

if [ ! -d '/usr/local/mysql/data/' ]; then
	_mysql_password="root"
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		echo 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
		echo 'Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
	fi

	cp -r $MYSQL_DUMP_DIR/* /var/lib/mysql/
	chown -R mysql /var/lib/mysql/

	/mysql-setup.sh

    TEMP_FILE='/opt/mysql-first-time.sql'
	$($cmd "--init-file=$TEMP_FILE")
else
	$($cmd)
fi
