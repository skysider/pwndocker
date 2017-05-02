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
    cmake \
    net-tools \
    libffi-dev \
    libssl-dev \
    python3-pip \
    python-pip \
    python-capstone \
    ruby2.3 \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    socat --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN pip3 install --no-cache-dir \
    ropper \
    unicorn \
    keystone-engine \
    capstone
    
RUN pip install --no-cache-dir \
    ropgadget \
    pwntools \
    zio \
    angr

RUN gem install \
    one_gadget && \
    rm -rf /var/lib/gems/2.3.*/cache/*
    
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/gef.sh | sh

COPY linux_server linux_serverx64 /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_serverx64

WORKDIR /ctf/work/

ENTRYPOINT ["/bin/bash"]
