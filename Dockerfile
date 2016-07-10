FROM phusion/baseimage
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV SHELL=/bin/bash \
    WORK_USER="docker" \
    WORK_HOME="/home/${WORK_USER}" \
    GIT_EMAIL="owen.ouyang@live.com" \
    GIT_NAME="Owen Ouyang" \
    CCACHE_DIR="/docker/ccache" \
    CCACHE_UMASK=002 \
    LOG_DIR="/var/log/docker" \
    TERM=dumb

USER root

RUN dpkg --add-architecture i386 && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    apt-get -o Dpkg::Options::="--force-overwrite" install -y \
              oracle-java8-installer \
              oracle-java8-set-default \
              curl \
              nodejs \
              npm \
              mkisofs \
              zip \
              unzip \
              python-dev \
              python-virtualenv \
              awscli \
              dosfstools \
              software-properties-common \
              build-essential \
              git \
              g++-multilib \
              distcc \
              ccache \
              icecc \
              make \
              bc \
              autoconf2.13 \
              bison \
              flex \
              gawk \
              lib32ncurses5-dev \
              lib32z1-dev \
              zlib1g:amd64 \
              zlib1g-dev:amd64 \
              zlib1g:i386 \
              zlib1g-dev:i386 \
              libgl1-mesa-dev \
              libx11-dev \
              libxml2-utils \
              libxrender1 \
              libasound2 \
              libatk1.0 \
              libice6 \
              libfontconfig1:amd64 \
              libxcomposite-dev \
              libgtk2.0-0 \
              libxtst6:amd64 \
              libxtst6:i386 \
              libxt-dev && \
    update-java-alternatives -s java-8-oracle && \
    echo { \"allow_root\": true } >> /root/.bowerrc && \
    ln -s `which nodejs` /usr/local/bin/node && \
    npm install -g \
            babel-cli \
            npm \
            bower \
            uglify-js && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    git config --global user.email "${GIT_EMAIL}" && \
    git config --global user.name "${GIT_NAME}" && \
    git config --global color.ui false && \
    groupadd -r ${WORK_USER} -g 1000 && \
    useradd -r -u 1000 -s /bin/bash -m -g ${WORK_USER} ${WORK_USER} && \
    echo "${WORK_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo nameserver 8.8.8.8 >> /etc/resolv.conf && \
    ccache --max-size 10GB

USER ${WORK_USER}

VOLUME ["${WORK_HOME}", "${LOG_DIR}"]
WORKDIR ${WORK_HOME}

CMD ["/sbin/my_init"]
