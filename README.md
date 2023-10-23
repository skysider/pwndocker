Pwndocker
=========
A docker environment for pwn in ctf based on **phusion/baseimage:focal-1.2.0**, which is a modified ubuntu 20.04 baseimage for docker

### Usage

	docker-compose up -d
	docker exec -it pwn_test /bin/bash


### included software

- [pwntools](https://github.com/Gallopsled/pwntools)  —— CTF framework and exploit development library
- [pwndbg](https://github.com/pwndbg/pwndbg)  —— a GDB plug-in that makes debugging with GDB suck less, with a focus on features needed by low-level software developers, hardware hackers, reverse-engineers and exploit developers
- [pwngdb](https://github.com/scwuaptx/Pwngdb) —— gdb for pwn
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget)  —— facilitate ROP exploitation tool
- [roputils](https://github.com/inaz2/roputils) 	—— A Return-oriented Programming toolkit
- [one_gadget](https://github.com/david942j/one_gadget) —— A searching one-gadget of execve('/bin/sh', NULL, NULL) tool for amd64 and i386
- [angr](https://github.com/angr/angr)   ——  A platform-agnostic binary analysis framework
- [radare2](https://github.com/radare/radare2) ——  A rewrite from scratch of radare in order to provide a set of libraries and tools to work with binary files
- [seccomp-tools](https://github.com/david942j/seccomp-tools) —— Provide powerful tools for seccomp analysis
- linux_server[64] 	—— IDA 7.0 debug server for linux
- [tmux](https://tmux.github.io/) 	—— a terminal multiplexer
- [ltrace](https://linux.die.net/man/1/ltrace)      —— trace library function call
- [strace](https://linux.die.net/man/1/strace)     —— trace system call

### included glibc

Default compiled glibc path is `/glibc`.

- 2.19  —— ubuntu 12.04 default libc version
- 2.23  —— ubuntu 16.04 default libc version
- 2.24  —— introduce vtable check in file struct
- 2.27  —— ubuntu 18.04 default glibc version
- 2.31  —— ubuntu 20.04 default glibc version(built-in)
- 2.28~2.30,2.33~2.36  —— latest libc versions

### Q&A

#### How to run in custom libc version?

```shell
cp /glibc/2.27/64/lib/ld-2.27.so /tmp/ld-2.27.so
patchelf --set-interpreter /tmp/ld-2.27.so ./test
LD_PRELOAD=./libc.so.6 ./test
```

or

```python
from pwn import *
p = process(["/path/to/ld.so", "./test"], env={"LD_PRELOAD":"/path/to/libc.so.6"})

```

#### How to run in custom libc version with other lib?
if you want to run binary with glibc version 2.28:

```shell
root@pwn:/ctf/work# ldd /bin/ls
linux-vdso.so.1 (0x00007ffe065d3000)
libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f004089e000)
libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f00406ac000)
libpcre2-8.so.0 => /lib/x86_64-linux-gnu/libpcre2-8.so.0 (0x00007f004061c000)
libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f0040616000)
/lib64/ld-linux-x86-64.so.2 (0x00007f00408f8000)

root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls
/bin/ls: error while loading shared libraries: libselinux.so.1: cannot open shared object file: No such file or directory
```
You can copy /lib/x86_64-linux-gnu/libselinux.so.1 and /lib/x86_64-linux-gnu/libpcre2-8.so.0 to /glibc/2.28/64/lib/, and sometimes it fails because the built-in libselinux.so.1 requires higher version libc:

```
root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls
/bin/ls: /glibc/2.28/64/lib/libc.so.6: version `GLIBC_2.30' not found (required by /glibc/2.28/64/lib/libselinux.so.1)
```

it can be solved by copying libselinux.so.1 from ubuntu 18.04 which glibc version is 2.27 to /glibc/2.28/64/lib:
```
docker run -itd --name u18 ubuntu:18.04 /bin/bash
docker cp -L u18:/lib/x86_64-linux-gnu/libselinux.so.1 .
docker cp -L u18:/lib/x86_64-linux-gnu/libpcre2-8.so.0 .
docker cp libselinux.so.1 pwn:/glibc/2.28/64/lib/
docker cp libpcre2-8.so.0 pwn:/glibc/2.28/64/lib/
```

And now it succeeds:

```
root@pwn:/ctf/work# /glibc/2.28/64/ld-2.28.so /bin/ls -l /
```

### ChangeLog

#### 2023-10-22
add `zsh` and `ohmyzsh` to docker image, update `pwntools` version to 4.11.0

#### 2023-01-27
add `glibc` versions 2.33~2.36 to docker image, and update `pwntools` version to `4.9.0`

#### 2022-03-06
add `pwntools_version` docker build argument, `4.8.0b0` is set in repo docker build actions

#### 2022-2-10
add docker-compose.yml

#### 2021-10-25
add docker build action and update radare2 version to latest

#### 2020-09-06
update base image to 20.04(glibc 2.31) and add glibc 2.27

#### 2020-05-22
update radare2 to version 4.4.0 and add r2pipe python binding

#### 2020-04-11
add libc 2.30 and 2.31

#### 2020-02-19

python packages switched to python3 version, remove roputils.py
