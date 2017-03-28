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

- [pwntools](https://github.com/Gallopsled/pwntools) 	—— CTF framework and exploit development library
- [zio](https://github.com/zTrix/zio)   —— An easy-to-use io library for pwn development
- [gdb-peda](https://github.com/longld/peda) 	—— 
Python Exploit Development Assistance for GDB
- [Pwngdb](https://github.com/scwuaptx/Pwngdb) 	—— GDB for pwn
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget) 	—— facilitate ROP exploitation tool
- [roputils](https://github.com/inaz2/roputils) 	—— A Return-oriented Programming toolkit
- [one_gadget](https://github.com/david942j/one_gadget) —— A searching one-gadget of execve('/bin/sh', NULL, NULL) tool for amd64 and i386
- linux_server[x64] 	—— IDA 6.8 debug server for linux
- [tmux](https://tmux.github.io/) 	—— a terminal multiplexer
- [ltrace](https://linux.die.net/man/1/ltrace)	—— trace library function call
- [strace](https://linux.die.net/man/1/strace) —— trace system call