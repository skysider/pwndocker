FROM phusion/baseimage:master-amd64
LABEL maintainer="skysider <skysider@163.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Asia/Shanghai

RUN apt-get -y update && \
    apt install -y \
    libc6-dbg \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison \
    rpm2cpio cpio \
    zstd \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    pwntools \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh
RUN wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py

WORKDIR /ctf/work/

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64

COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64

COPY linux_server linux_server64  /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64

CMD ["/sbin/my_init"]
