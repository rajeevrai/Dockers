FROM rajeev/debian


ENV MYSQL_MAJOR_VERSION 5.7
ENV MYSQL_VERSION 5.7.13
ENV MYSQL_FILE_NAME mysql-$MYSQL_VERSION.tar.gz
ENV MYSQL_SRC_DIR $SOURCE_DIR/$MYSQL_FILE_NAME
ENV MYSQL_INSTALL_DIR /usr/local/mysql-$MYSQL_VERSION

ENV BOOST_VERSION 1.59.0
ENV BOOST_FILE_NAME boost_1_59_0


RUN rm -rf $SOURCE_DIR \
    && mkdir $SOURCE_DIR \
    && cd $SOURCE_DIR \
    && wget http://dev.mysql.com/get/Downloads/MySQL-$MYSQL_MAJOR_VERSION/$MYSQL_FILE_NAME \
    && tar -xvzf $MYSQL_FILE_NAME \
    && wget http://downloads.sourceforge.net/project/boost/boost/$BOOST_VERSION/$BOOST_FILE_NAME.tar.gz



RUN cd $SOURCE_DIR/mysql-$MYSQL_VERSION \
    && cmake . -DMYSQL_DATADIR=$MYSQL_INSTALL_DIR/data_dump/ -DCMAKE_INSTALL_PREFIX=$MYSQL_INSTALL_DIR/ -DWITH_BOOST=$SOURCE_DIR/$BOOST_FILE_NAME.tar.gz \
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
    && ln -s $MYSQL_INSTALL_DIR mysql \
    && rm -rf $SOURCE_DIR \
    && updatedb


ADD scripts/init-file.sql $MYSQL_INSTALL_DIR/


WORKDIR $CODE_DIR

EXPOSE 3306

CMD ["/bin/bash"]

