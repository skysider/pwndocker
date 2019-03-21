Pwndocker
=========
A docker environment for pwn in ctf based on **phusion/baseimage**, which is a modified ubuntu 16.04 baseimage for docker

### Usage

	docker run -it \
		--rm \
		-h ${ctf_name} \
		--name ${ctf_name} \
		-v $(pwd)/${ctf_name}:/ctf/work \
		-p 23946:23946 \
		--cap-add=SYS_PTRACE \
		skysider/pwndocker


### included software

- [pwntools](https://github.com/Gallopsled/pwntools)  —— CTF framework and exploit development library
- [pwndbg](https://github.com/pwndbg/pwndbg)  —— a GDB plug-in that makes debugging with GDB suck less, with a focus on features needed by low-level software developers, hardware hackers, reverse-engineers and exploit developers
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget)  —— facilitate ROP exploitation tool
- [roputils](https://github.com/inaz2/roputils) 	—— A Return-oriented Programming toolkit
- [one_gadget](https://github.com/david942j/one_gadget) —— A searching one-gadget of execve('/bin/sh', NULL, NULL) tool for amd64 and i386
- [angr](https://github.com/angr/angr)   ——  A platform-agnostic binary analysis framework
- [radare2](https://github.com/radare/radare2) ——  A rewrite from scratch of radare in order to provide a set of libraries and tools to work with binary files
- [welpwn](https://github.com/matrix1001/welpwn) —— designed to make pwnning an art, freeing you from dozens of meaningless jobs.
- linux_server[64] 	—— IDA 7.0 debug server for linux
- [tmux](https://tmux.github.io/) 	—— a terminal multiplexer
- [ltrace](https://linux.die.net/man/1/ltrace)      —— trace library function call
- [strace](https://linux.die.net/man/1/strace)     —— trace system call

### included glibc

Default compiled glibc path is `/glibc`.

- 2.19  —— ubuntu 12.04 default libc version
- 2.23  —— pwndocker default libc version
- 2.24  —— introduce vtable check in file struct
- 2.27  —— intruduce tcache in heap (since 2.26)
- 2.28  —— latest libc version

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
