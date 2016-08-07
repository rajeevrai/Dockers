#!/usr/bin/env bash

set -e

TEMP_FILE='/opt/mysql-first-time.sql'
echo 'DELETE FROM mysql.user ;' >>  "$TEMP_FILE"
echo "CREATE USER 'root'@'%' IDENTIFIED BY 'root' ;" >>  "$TEMP_FILE"
echo "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;" >>  "$TEMP_FILE"
echo 'DROP DATABASE IF EXISTS test ;' >>  "$TEMP_FILE"

echo 'FLUSH PRIVILEGES ;' >> "$TEMP_FILE"

echo $TEMP_FILE