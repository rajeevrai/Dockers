FROM rajeev/debian

ENV NGINX_VERSION 1.11.2
ENV NGINX_FILE_NAME nginx-$NGINX_VERSION.tar.gz
ENV NGINX_SRC_DIR $SOURCE_DIR/$NGINX_FILE_NAME
ENV NGINX_INSTALL_DIR /usr/local/nginx-$NGINX_VERSION


RUN rm -rf $SOURCE_DIR \
    && mkdir $SOURCE_DIR \
    && cd $SOURCE_DIR \
    && wget http://nginx.org/download/$NGINX_FILE_NAME \
    && tar -xvzf $NGINX_FILE_NAME


RUN cd $SOURCE_DIR/nginx-$NGINX_VERSION \
    && ./configure --prefix=$NGINX_INSTALL_DIR --with-http_ssl_module --with-http_v2_module \
    && make \
    && make install \
    && addgroup adaemon \
    && useradd adaemon -g adaemon \
    && rm -rf $SOURCE_DIR \
    && cd /usr/local/ \
    && ln -s $NGINX_INSTALL_DIR nginx \
    && rm -rf $SOURCE_DIR \
    && updatedb


ADD conf/nginx.conf $NGINX_INSTALL_DIR/conf/
#ADD conf/nginx_supervisor.conf /etc/supervisor/conf.d/

WORKDIR $NGINX_INSTALL_DIR/html/

#VOLUME ["$NGINX_INSTALL_DIR/logs"]

EXPOSE 80 443

CMD ["/bin/bash"]
