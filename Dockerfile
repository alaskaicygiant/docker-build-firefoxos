FROM quay.io/alaska/build-base:octans
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV SHELL=/bin/bash \
    WORK_USER="docker" \
    WORK_HOME="/build" \
    GIT_EMAIL="owen.ouyang@live.com" \
    GIT_NAME="Owen Ouyang" \
    LOG_DIR="/var/log/docker" \
    TERM=dumb \
    B2G_REPO="https://github.com/mozilla-b2g/B2G.git" \
    CCACHE_DIR="/build/ccache" \
    CCACHE_UMASK=002

RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://archive.canonical.com/ trusty partner"
RUN add-apt-repository ppa:webupd8team/java
RUN dpkg --add-architecture i386
RUN apt-get update

RUN apt-get install -y \
              gcc-4.7 \
              g++-4.7 \
              g++-4.7-multilib 
# https://gist.github.com/mugli/8720670
# Enable silent install
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 3
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.7 3

VOLUME ["${WORK_HOME}", "${LOG_DIR}"]
WORKDIR ${WORK_HOME}

CMD ["/sbin/my_init"]
