FROM rajeev/debian


ENV NODE_VERSION 4.4.2
ENV NODE_FILE_NAME node-v$NODE_VERSION.tar.gz
ENV NODE_SRC_DIR $SOURCE_DIR/$NODE_FILE_NAME
ENV NODE_INSTALL_DIR /usr/local/node-$NODE_VERSION


RUN rm -rf $SOURCE_DIR \
    && mkdir $SOURCE_DIR \
    && cd $SOURCE_DIR \
    && wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz \
    && tar -xvzf $NODE_FILE_NAME


RUN cd $SOURCE_DIR/node-v$NODE_VERSION \
    && ./configure --prefix=$NODE_INSTALL_DIR \
    && make \
    && make install \
    && rm -rf $SOURCE_DIR \
    && cd /usr/local/ \
    && ln -s $NODE_INSTALL_DIR node \
    && rm -rf $SOURCE_DIR \
    && updatedb


#ADD conf/nodejs_supervisor.conf /etc/supervisor/conf.d/


EXPOSE 9000


CMD ["/bin/bash"]
#CMD ["/usr/bin/supervisord", "-n"]
