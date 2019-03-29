Pwndocker
=========
A docker environment for pwn in ctf based on **ubuntu18.04**

### Usage

	docker run -it \
		--rm \
		-h ${ctf_name} \
		--name ${ctf_name} \
		-v $(pwd)/${ctf_name}:/ctf/work \
		-p 23946:23946 \
		--cap-add=SYS_PTRACE \
		skysider/pwndocker:18.04


​
### included software

- [pwntools](https://github.com/Gallopsled/pwntools) 	—— CTF framework and exploit development library
- [pwndbg](https://github.com/pwndbg/pwndbg#readme)  ——  Exploit Development and Reverse Engineering with GDB Made Easy
- [pwngdb](https://github.com/scwuaptx/Pwngdb) —— gdb for pwn
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget) 	—— facilitate ROP exploitation tool
- [roputils](https://github.com/inaz2/roputils) 	—— A Return-oriented Programming toolkit
- [one_gadget](https://github.com/david942j/one_gadget) —— A searching one-gadget of execve('/bin/sh', NULL, NULL) tool for amd64 and i386
- [angr](https://github.com/angr/angr)   ——  A platform-agnostic binary analysis framework
- [radare2](https://github.com/radare/radare2) ——  A rewrite from scratch of radare in order to provide a set of libraries and tools to work with binary files
- linux_server[x64] 	—— IDA 6.8 debug server for linux
- [tmux](https://tmux.github.io/) 	—— a terminal multiplexer
- [ltrace](https://linux.die.net/man/1/ltrace)	—— trace library function call
- [strace](https://linux.die.net/man/1/strace) —— trace system call

### included glibc

Default compiled glibc path is `/glibc`.

- 2.19  —— ubuntu 12.04 default libc version
- 2.23  —— ubuntu 16.04 default libc version
- 2.24  —— introduce vtable check in file struct
- 2.27  —— ubuntu 18.04 (intruduce tcache in heap since 2.26)
- 2.28  —— latest libc version

#### How to run in custom libc version?

```shell
cp /glibc/2.28/64/lib/ld-2.28.so /tmp/ld-2.28.so
patchelf --set-interpreter /tmp/ld-2.28.so ./test
LD_PRELOAD=./libc.so.6 ./test
```

or

```python
from pwn import *
p = process(["/path/to/ld.so", "./test"], env={"LD_PRELOAD":"/path/to/libc.so.6"})

```
