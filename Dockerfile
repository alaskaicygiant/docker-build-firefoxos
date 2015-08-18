FROM phusion/baseimage:0.9.9
MAINTAINER Owen Ouyang <owen.ouyang@live.com>

ENV SHELL=/bin/bash \
    WORK_USER="docker" \
    WORK_HOME="/home/docker" \
    GIT_EMAIL="rename@to.your.mail" \
    GIT_NAME="rename to your name" \
    LOG_DIR="/var/log/docker"

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://archive.canonical.com/ trusty partner"
RUN add-opt-repository ppa:webupd8team/java
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install --no-install-recommends \
              autoconf2.13 \
              bison \
              bzip2 \
              ccache \
              curl \
              flex \
              gawk \
              gcc \
              g++ \
              g++-multilib \
              gcc-4.6 \
              g++-4.6 \
              g++-4.6-mutilib \
              git \
              lib32ncurses5-dev \
              lib32z1-dev \
              zlib1g:amd64 \
              zlib1g-dev:amd64 \
              zlib1g:i386 \
              zlib1g-dev:i386 \
              libgl1-mesa-dev \
              libx11-dev \
              make \
              zip \
              libxml2-utils \
              python \
              oracle-java6-installer \
              dosfstools \
              libxrender1 \
              libasound2 \
              libatk1.0 \
              libice6 \
              wget \
              curl \
              python-setuptools \
              python-virtualenv \
              python-pip \
              android-tools-adb \
              android-tools-fastboot \
              python-dev \
              libusb-1.0-0 \
              libusb-1.0-0-dev \
              usbutils \
              unzip 

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 2
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 1
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 2
RUN update-alternatives --set gcc "/usr/bin/gcc-4.6"
RUN update-alternatives --set g++ "/usr/bin/g++-4.6"

# add user
RUN groupadd -r docker -g 1000 && useradd -r -u 1000 -s /bin/bash -m -g docker docker
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER docker

RUN git config --global user.email "${GIT_EMAIL}"
RUN git config --global user.name "${GIT_NAME}"

# Clean up any files used by apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["${WORK_HOME}", "${LOG_DIR}"]
WORKDIR ${WORK_HOME}

# --privileged --expose 5037 -v /dev/bus/usb:/dev/bus/usb