sleep 1
/usr/local/apache/bin/httpd -k start
sleep 1
/usr/local/nginx/sbin/nginx
sleep 1
/usr/local/mysql/bin/mysqld_safe &
sleep 5
/usr/local/mysql/bin/mysql -uroot  -S /tmp/mysql6.sock < /usr/local/mysql/init-file.sql
