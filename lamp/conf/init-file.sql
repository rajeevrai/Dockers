USE mysql;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'pswd';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'pswd';

FLUSH PRIVILEGES;

FLUSH TABLES;