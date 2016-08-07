FROM debian:jessie

ENV HOME /root
ENV TIMEZONE Asia/Kolkata
ENV CODE_DIR /apps/rajeev
ENV SOURCE_DIR /usr/local/sources
ENV DEBIAN_FRONTEND noninteractive


RUN echo "$TIMEZONE" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && apt-get update -y --fix-missing \
  && apt-get upgrade -y --fix-missing


ADD conf/start-services.php $CODE_DIR/
ADD conf/.bashrc $HOME/
ADD conf/hosts /etc/


RUN apt-get install -y gcc g++ libtool autoconf cmake mcrypt libmcrypt-dev curl gawk openssl libxml2 automake locate mlocate zip unzip bzip2 git telnet subversion supervisor bison wget apt-utils libncurses5-dev python-dev libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev libicu-dev libjpeg-dev libpng12-dev libxml2-dev libxslt-dev ncurses-dev libc6-dev build-essential re2c libcurl4-openssl-dev pkg-config libssl-dev net-tools vim vim-tiny screen \
  && apt-get autoclean \
  && apt-get autoremove -y \
  && . $HOME/.bashrc \
  && updatedb


CMD ["/bin/bash"]
