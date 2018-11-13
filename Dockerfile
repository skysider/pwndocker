FROM ubuntu:18.04
MAINTAINER skysider <skysider@163.com>

ENV LANG C.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    python \
    python-pip \
    python3 \
    python3-pip \
    net-tools \
    libffi-dev \
    libssl-dev \
    python-dev \
    build-essential \
    ruby \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    sshpass \
    bison --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr

RUN python -m pip install -U pip setuptools && \
    python -m pip install --no-cache-dir \
    -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    ropgadget \
    pwntools \
    zio \
    lief \
    smmap2 \
    z3-solver \
    apscheduler \
    ropper && \
    python -m pip install -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    --upgrade pwntools

RUN gem install \
    one_gadget && \
    rm -rf /var/lib/gems/2.*/cache/*

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone https://github.com/skysider/LibcSearcher.git  LibcSearcher && \
    cd LibcSearcher && git submodule update --init --recursive && \
    cd libc-database && git pull origin master && cd .. && \
    python setup.py develop && cd libc-database && ./get || ls

WORKDIR /ctf/work/

COPY linux_server linux_server64 build_glibc.sh /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64 /ctf/build_glibc.sh && \
    /ctf/build_glibc.sh 2.23 && \
    /ctf/build_glibc.sh 2.24 && \
    /ctf/build_glibc.sh 2.26

ENTRYPOINT ["/bin/bash"]
