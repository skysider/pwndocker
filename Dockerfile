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
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN pip3 install --no-cache-dir \
    ropper \
    unicorn \
    keystone-engine \
    capstone

RUN pip install --upgrade setuptools && \
    pip install --no-cache-dir \
    ropgadget \
    pwntools \
    zio \
    angr \
    lief \
    z3-solver \
    apscheduler && \
    pip install --upgrade pwntools

RUN gem install \
    one_gadget && \
    rm -rf /var/lib/gems/2.3.*/cache/*

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && sed -i s/sudo//g setup.sh && \
    chmod +x setup.sh && ./setup.sh

RUN git clone https://github.com/skysider/LibcSearcher.git LibcSearcher && \
    cd LibcSearcher && git submodule update --init --recursive && \ 
    cd libc-database && git pull origin master && cd .. && \
    python setup.py develop && cd libc-database && ./get || ls

WORKDIR /ctf/work/

RUN cd /ctf && mkdir glibc && cd glibc && mkdir 2.24 && cd /ctf/work && \
    wget http://mirrors.ustc.edu.cn/gnu/libc/glibc-2.24.tar.gz && \
    tar xf glibc-2.24.tar.gz && cd glibc-2.24 && mkdir build && cd build && \
    ../configure --prefix=/ctf/glibc/2.24/ --disable-werror --enable-debug=yes && \
    make && make install && cd ../../ && rm -rf glibc-2.24 && rm glibc-2.24.tar.gz

COPY linux_server linux_server64 /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64


ENTRYPOINT ["/bin/bash"]
