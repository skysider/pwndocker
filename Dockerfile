FROM phusion/baseimage:latest
MAINTAINER skysider <skysider@163.com>

RUN dpkg --add-architecture i386 && \
	apt-get -y update && \
	apt install -y \
	net-tools \
	libffi-dev \
	libssl-dev \
	python \
	python-pip \
	python-capstone \
	tmux \
	strace \
	ltrace \
	git \
	wget \
	gdb --fix-missing && \
	rm -rf /var/lib/apt/list/*

RUN pip install \
	ropgadget \
	pwntools && \
	rm -rf ~/.cache/pip/*

RUN git clone https://github.com/longld/peda.git ~/peda && \
	git clone https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb && \
	cp ~/Pwngdb/.gdbinit ~/

RUN mkdir -p /ctf/work && \
	wget https://raw.githubusercontent.com/inaz2/roputils/master/roputils.py -O /ctf/roputils.py

COPY linux_server linux_serverx64 /ctf/

WORKDIR /ctf/work/

ENTRYPOINT ["/bin/bash"]