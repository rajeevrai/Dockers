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


RUN rm -rf $SOURCE_DIR \
    && mkdir $SOURCE_DIR \
    && cd $SOURCE_DIR \
    && wget http://www.us.apache.org/dist/apr/$HTTPD_APR_FILE_NAME \
    && wget http://www.us.apache.org/dist/apr/$HTTPD_APR_UTIL_FILE_NAME \
    && wget http://www.us.apache.org/dist/httpd/$HTTPD_FILE_NAME \
    && wget http://in1.php.net/distributions/$PHP_FILE_NAME \
    && tar -xvzf $HTTPD_APR_FILE_NAME \
    && tar -xvzf $HTTPD_APR_UTIL_FILE_NAME \
    && tar -xvzf $HTTPD_FILE_NAME \
    && tar -xvzf $PHP_FILE_NAME


### APR Installation - Starts ###
RUN cd $SOURCE_DIR/apr-$HTTPD_APR_VERSION \
    && ./configure --prefix=$HTTPD_APR_INSTALL_DIR \
    && make \
    && make install \
### APR Installation - Ends ### 
### APRUtil Installation - Starts ###
    && cd $SOURCE_DIR/apr-util-$HTTPD_APR_UTIL_VERSION \
    && ./configure --prefix=$HTTPD_APR_UTIL_INSTALL_DIR --with-apr=$HTTPD_APR_INSTALL_DIR \
    && make \
    && make install \
### APRUtil Installation - Ends ###
### Apache Installation - Starts ###
    && cd $SOURCE_DIR/httpd-$HTTPD_VERSION \
    && ./configure --prefix=$HTTPD_INSTALL_DIR --with-apr=$HTTPD_APR_INSTALL_DIR --with-apr-util=$HTTPD_APR_UTIL_INSTALL_DIR --enable-so --enable-rewrite --with-crypto \
    && make \
    && make install \
    && addgroup adaemon \
    && useradd adaemon -g adaemon \
    && mkdir -p /apps \
    && mkdir -p /apps/rajeev \
    && cd /usr/local/ \
    && ln -s $HTTPD_INSTALL_DIR httpd \
    && ln -s $HTTPD_INSTALL_DIR apache
### Apache Installation - Ends ###


### PHP Installation - Starts ###
RUN cd $SOURCE_DIR/php-$PHP_VERSION \
    && ./configure --prefix=$PHP_INSTALL_DIR --with-apxs2=$HTTPD_INSTALL_DIR/bin/apxs --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-pdo-mysql --with-mysqli --enable-sockets --with-mcrypt --with-curl --enable-opcache --with-openssl --enable-intl --enable-mbstring \
    && make \
    && make install \
    && cd /usr/local/ \
    && ln -s $PHP_INSTALL_DIR php \
    && rm -rf $SOURCE_DIR \
    && updatedb
### PHP Installation - Ends ###


ADD conf/httpd.conf $HTTPD_INSTALL_DIR/conf/
ADD conf/httpd-vhosts.conf $HTTPD_INSTALL_DIR/conf/
ADD conf/php.ini $PHP_INSTALL_DIR/lib/


#RUN mkdir $SOURCE_DIR \
#    && cd $SOURCE_DIR \
#    && git clone https://github.com/phpredis/phpredis.git \
#    && cd phpredis \
#    && git checkout php7 \
#    && $PHP_INSTALL_DIR/bin/phpize \
#    && ./configure --with-php-config=$PHP_INSTALL_DIR/bin/php-config \
#    && make \
#    && make install \
#    && echo "extension=phpredis.so" >> $PHP_INSTALL_DIR/lib/php.ini \
#    && rm -rf $SOURCE_DIR


WORKDIR $CODE_DIR


#VOLUME ["/apps", "$HTTPD_INSTALL_DIR/logs"]


CMD ["/bin/bash"]
#ENTRYPOINT ["/usr/bin/supervisord", "-n"]


EXPOSE 8080
