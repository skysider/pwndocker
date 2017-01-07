FROM ubuntu:16.04
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
	git \
	wget \
	gdb --fix-missing && \
	rm -rf /var/lib/apt/list/*

RUN pip install \
	ropgadget \
	pwntools && \
	rm -rf ~/.cache/pip/*

RUN git clone https://github.com/longld/peda.git ~/peda && \
	echo "source ~/peda/peda.py" >> ~/.gdbinit

WORKDIR /ctf

RUN wget https://raw.githubusercontent.com/inaz2/roputils/master/roputils.py

COPY linux_server linux_serverx64 .

ENTRYPOINT ["/bin/bash"]