FROM phusion/baseimage:master-amd64
MAINTAINER skysider <skysider@163.com>

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Asia/Shanghai

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
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
    sudo \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN wget https://github.com/radareorg/radare2/releases/download/4.4.0/radare2_4.4.0_amd64.deb && \
    dpkg -i radare2_4.4.0_amd64.deb && rm radare2_4.4.0_amd64.deb

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

WORKDIR /ctf/work/

COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

COPY --from=skysider/glibc_builder64:2.30 /glibc/2.30/64 /glibc/2.30/64
COPY --from=skysider/glibc_builder32:2.30 /glibc/2.30/32 /glibc/2.30/32

COPY --from=skysider/glibc_builder64:2.31 /glibc/2.31/64 /glibc/2.31/64
COPY --from=skysider/glibc_builder32:2.31 /glibc/2.31/32 /glibc/2.31/32

COPY linux_server linux_server64  /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64

# Create non-root user
RUN useradd -m pwn && \
  adduser pwn sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  echo "pwn:pwn" | chpasswd

# Initilise base user
USER pwn
ENV HOME /home/pwn

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg ${HOME}/pwndbg && \
    cd ${HOME}/pwndbg && chmod +x setup.sh && ./setup.sh && \
    git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git ${HOME}/Pwngdb && \
    cd ${HOME}/Pwngdb && cat /home/pwn/Pwngdb/.gdbinit  >> ${HOME}/.gdbinit && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" ${HOME}/.gdbinit && \
    git clone --depth 1 https://github.com/niklasb/libc-database.git ${HOME}/libc-database && \
    cd ${HOME}/libc-database && ./get || echo "/libc-database/" > ${HOME}/.libcdb_path

ENTRYPOINT ["sleep", "infinity"]
