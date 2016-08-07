FROM rajeev/debian


ENV HTTPD_APR_VERSION 1.5.2
ENV HTTPD_APR_FILE_NAME apr-$HTTPD_APR_VERSION.tar.gz
ENV HTTPD_APR_SRC_DIR $SOURCE_DIR/$HTTPD_APR_FILE_NAME
ENV HTTPD_APR_INSTALL_DIR /usr/local/apr-$HTTPD_APR_VERSION

ENV HTTPD_APR_UTIL_VERSION 1.5.4
ENV HTTPD_APR_UTIL_FILE_NAME apr-util-$HTTPD_APR_UTIL_VERSION.tar.gz
ENV HTTPD_APR_UTIL_SRC_DIR $SOURCE_DIR/$HTTPD_APR_UTIL_FILE_NAME
ENV HTTPD_APR_UTIL_INSTALL_DIR /usr/local/apr-util-$HTTPD_APR_UTIL_VERSION

ENV HTTPD_VERSION 2.4.23
ENV HTTPD_FILE_NAME httpd-$HTTPD_VERSION.tar.gz
ENV HTTPD_SRC_DIR $SOURCE_DIR/$HTTPD_FILE_NAME
ENV HTTPD_INSTALL_DIR /usr/local/httpd-$HTTPD_VERSION

ENV PHP_VERSION 7.0.9
ENV PHP_FILE_NAME php-$PHP_VERSION.tar.gz
ENV PHP_SRC_DIR $SOURCE_DIR/$PHP_FILE_NAME
ENV PHP_INSTALL_DIR /usr/local/php-$PHP_VERSION

ENV NGINX_VERSION 1.11.2
ENV NGINX_FILE_NAME nginx-$NGINX_VERSION.tar.gz
ENV NGINX_SRC_DIR $SOURCE_DIR/$NGINX_FILE_NAME
ENV NGINX_INSTALL_DIR /usr/local/nginx-$NGINX_VERSION

ENV MYSQL_MAJOR_VERSION 5.7
ENV MYSQL_VERSION 5.7.13
ENV MYSQL_FILE_NAME mysql-$MYSQL_VERSION.tar.gz
ENV MYSQL_SRC_DIR $SOURCE_DIR/$MYSQL_FILE_NAME
ENV MYSQL_INSTALL_DIR /usr/local/mysql-$MYSQL_VERSION

ENV BOOST_VERSION 1.59.0
ENV BOOST_FILE_NAME boost_1_59_0


RUN mkdir $SOURCE_DIR \
    && cd $SOURCE_DIR \
    && wget http://www.us.apache.org/dist/apr/$HTTPD_APR_FILE_NAME \
    && wget http://www.us.apache.org/dist/apr/$HTTPD_APR_UTIL_FILE_NAME \
    && wget http://www.us.apache.org/dist/httpd/$HTTPD_FILE_NAME \
    && wget http://in1.php.net/distributions/$PHP_FILE_NAME \
    && wget http://nginx.org/download/$NGINX_FILE_NAME \
    && wget http://dev.mysql.com/get/Downloads/MySQL-$MYSQL_MAJOR_VERSION/$MYSQL_FILE_NAME \
    && wget http://downloads.sourceforge.net/project/boost/boost/$BOOST_VERSION/$BOOST_FILE_NAME.tar.gz \
    && tar -xvzf $HTTPD_APR_FILE_NAME \
    && tar -xvzf $HTTPD_APR_UTIL_FILE_NAME \
    && tar -xvzf $HTTPD_FILE_NAME \
    && tar -xvzf $PHP_FILE_NAME \
    && tar -xvzf $NGINX_FILE_NAME \
    && tar -xvzf $MYSQL_FILE_NAME



RUN cd $SOURCE_DIR/nginx-$NGINX_VERSION \
    && ./configure --prefix=$NGINX_INSTALL_DIR --with-http_ssl_module --with-http_v2_module \
    && make \
    && make install \
    && addgroup adaemon \
    && useradd adaemon -g adaemon \
    && cd /usr/local/ \
    && ln -s $NGINX_INSTALL_DIR nginx



RUN cd $SOURCE_DIR/apr-$HTTPD_APR_VERSION \
    && ./configure --prefix=$HTTPD_APR_INSTALL_DIR \
    && make \
    && make install \
    && cd $SOURCE_DIR/apr-util-$HTTPD_APR_UTIL_VERSION \
    && ./configure --prefix=$HTTPD_APR_UTIL_INSTALL_DIR --with-apr=$HTTPD_APR_INSTALL_DIR \
    && make \
    && make install \
    && cd $SOURCE_DIR/httpd-$HTTPD_VERSION \
    && ./configure --prefix=$HTTPD_INSTALL_DIR --with-apr=$HTTPD_APR_INSTALL_DIR --with-apr-util=$HTTPD_APR_UTIL_INSTALL_DIR --enable-so --enable-rewrite --with-crypto \
    && make \
    && make install \
    && mkdir -p $CODE_DIR \
    && cd /usr/local/ \
    && ln -s $HTTPD_INSTALL_DIR httpd \
    && ln -s $HTTPD_INSTALL_DIR apache



RUN cd $SOURCE_DIR/mysql-$MYSQL_VERSION \
    && cmake . -DMYSQL_DATADIR=$MYSQL_INSTALL_DIR/data_dump/ -DCMAKE_INSTALL_PREFIX=$MYSQL_INSTALL_DIR/ -DWITH_BOOST=$SOURCE_DIR/$BOOST_FILE_NAME.tar.gz \
    && make \
    && make install



RUN cd $SOURCE_DIR/php-$PHP_VERSION \
    && ./configure --prefix=$PHP_INSTALL_DIR --with-apxs2=$HTTPD_INSTALL_DIR/bin/apxs --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-pdo-mysql --with-mysqli --enable-sockets --with-mcrypt --with-curl --enable-opcache --with-openssl --enable-intl --enable-mbstring \
    && make \
    && make install


ADD conf/my.cnf $MYSQL_INSTALL_DIR/


RUN cd $SOURCE_DIR/mysql-$MYSQL_VERSION \
    && addgroup mysql \
    && useradd mysql -g mysql \
    && mkdir $MYSQL_INSTALL_DIR/data_dump \
    && chown -R mysql.mysql $MYSQL_INSTALL_DIR/ \
    && chmod -R 770 $MYSQL_INSTALL_DIR/data_dump/ \
    && $MYSQL_INSTALL_DIR/bin/mysqld --initialize-insecure --user=mysql \
    && chown -R mysql.mysql $MYSQL_INSTALL_DIR/ \
    && cd /usr/local/ \
    && ln -s $MYSQL_INSTALL_DIR mysql



RUN cd $SOURCE_DIR \
    && git clone https://github.com/php/pecl-database-mysql php-mysql --recursive \
    && cd php-mysql \
    && $PHP_INSTALL_DIR/bin/phpize \
    && ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config \
    && make \
    && make install \
    && cd /usr/local/bin/ \
    && ln -s $PHP_INSTALL_DIR/bin/php php \
    && cd $SOURCE_DIR \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && cd $SOURCE_DIR \
    && wget https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && cd $SOURCE_DIR \
    && /usr/local/bin/composer global require sstalle/php7cc \
    && cd /usr/local/bin/ \
    && ln -s $HOME/.composer/vendor/bin/php7cc php7cc \
    && cd /usr/local/ \
    && ln -s $PHP_INSTALL_DIR php \
    && rm -rf $SOURCE_DIR \
    && updatedb



ADD conf/httpd.conf $HTTPD_INSTALL_DIR/conf/
ADD conf/httpd-vhosts.conf $HTTPD_INSTALL_DIR/conf/
ADD conf/php.ini $PHP_INSTALL_DIR/lib/
ADD conf/nginx.conf $NGINX_INSTALL_DIR/conf/
ADD conf/init-file.sql $MYSQL_INSTALL_DIR/


#RUN mkdir $SOURCE_DIR \
#    && cd $SOURCE_DIR \
#    && wget "http://www.aerospike.com/download/server/3.8.4/artifact/debian8" -O aerospike.tar.gz \
#    && tar -xvzf aerospike.tar.gz


WORKDIR $CODE_DIR

EXPOSE 80 443

CMD ["/bin/bash"]
