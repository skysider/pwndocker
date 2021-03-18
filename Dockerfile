FROM  skysider/pwndocker:latest

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

#ENTRYPOINT ["sleep", "infinity"]
