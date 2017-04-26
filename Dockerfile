FROM phusion/baseimage:latest
MAINTAINER skysider <skysider@163.com>

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    net-tools \
    libffi-dev \
    libssl-dev \
    python3-pip \
    ruby2.3 \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN pip3 install --no-cache-dir \
    ropgadget \
    ropper \
    pwntools \
    zio \
    angr \
    unicorn \
    keystone-engine \
    capstone \
    ipython

RUN gem install \
    one_gadget && \
    rm -rf /var/lib/gems/2.3.*/cache/*
    
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/gef.sh | sh

RUN mkdir -p /ctf/work && \
    wget https://raw.githubusercontent.com/inaz2/roputils/master/roputils.py -O /ctf/roputils.py

COPY linux_server linux_serverx64 /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_serverx64

WORKDIR /ctf/work/

ENTRYPOINT ["/bin/bash"]
