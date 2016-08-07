<?php

$nginxInstallDir = '/usr/local/nginx';
$apacheInstallDir = '/usr/local/apache';
$mysqlInstallDir = '/usr/local/mysql';

$insideDockerDataDir = $mysqlInstallDir . '/data_dump';
$outsideDockerDataDir = $mysqlInstallDir . '/data';


$startNginx = (!isset($argv[1]) || stristr($argv[1], 'n'));
$startApache = (!isset($argv[1]) || stristr($argv[1], 'a') || stristr($argv[1], 'h'));
$startMysql = (!isset($argv[1]) || stristr($argv[1], 'm'));


if ($startNginx) {
    echo "starting nginx\n";
    exec("$nginxInstallDir/sbin/nginx -c $nginxInstallDir/conf/nginx.conf");
    sleep(1);
}

if ($startApache) {
    echo "starting apache\n";
    exec("$apacheInstallDir/bin/apachectl");
    sleep(1);
}

if ($startMysql) {
    $firstTimeUse = false;

    if (!file_exists($outsideDockerDataDir) || count(scandir($outsideDockerDataDir)) == 2) {
        $firstTimeUse = true;

        echo "copying dump mysql data\n";
        @mkdir($outsideDockerDataDir);

        exec("cp -r $insideDockerDataDir/* $outsideDockerDataDir/");
    }

    echo "chown mysql dir\n";
    @exec("cp $outsideDockerDataDir/*ib $insideDockerDataDir/");
    exec("chown -R mysql.mysql $outsideDockerDataDir");

    echo "starting mysql\n";
    exec("$mysqlInstallDir/bin/mysqld_safe  --user=mysql --datadir=$outsideDockerDataDir > /dev/null 2>/dev/null &");
    sleep(5);

    if ($firstTimeUse) {
        echo "configuring mysql\n";
        exec("$mysqlInstallDir/bin/mysql -uroot  -S /tmp/mysql6.sock < $mysqlInstallDir/init-file.sql");
    }
}

//unlink("$mysqlInstallDir/init-file.sql");

