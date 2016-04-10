FROM quay.io/alaskaicygiant/nodejs
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV SHELL=/bin/bash \
    WORK_USER="docker" \
    WORK_HOME="/build" \
    GIT_EMAIL="owen.ouyang@live.com" \
    GIT_NAME="Owen Ouyang" \
    CCACHE_DIR="/build/ccache" \
    CCACHE_UMASK=002

RUN dpkg --add-architecture i386
RUN apt-get update

RUN apt-get install -y wget \
              curl \
              mkisofs \
              zip \
              unzip \
              python \
              python-dev \
              python-virtualenv \
              awscli \
              dosfstools \
              gcc-4.6 \
              g++-4.6 \
              g++-4.6-multilib \
              gcc-4.7 \
              g++-4.7 \
              g++-4.7-multilib \
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
              libxt-dev

RUN echo { \"allow_root\": true } >> /root/.bowerrc
RUN npm install -g bower
RUN npm install -g babel-cli
RUN npm install -g uglify-js
RUN ln -s `which nodejs` /usr/local/bin/node

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 2
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 3
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.7 2
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 3
RUN update-alternatives --set gcc "/usr/bin/gcc-4.6"
RUN update-alternatives --set g++ "/usr/bin/g++-4.6"

# Clean up any files used by apt-get
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git config --global user.email "${GIT_EMAIL}"
RUN git config --global user.name "${GIT_NAME}"

# add user
RUN groupadd -r ${WORK_USER} -g 1000 && useradd -r -u 1000 -s /bin/bash -m -g ${WORK_USER} ${WORK_USER}
RUN echo "${WORK_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# USER ${WORK_USER}

RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime

VOLUME ["${WORK_HOME}", "${LOG_DIR}"]
WORKDIR ${WORK_HOME}

RUN echo nameserver 8.8.8.8 >> /etc/resolv.conf
RUN ccache --max-size 10GB
CMD ["/sbin/my_init"]
