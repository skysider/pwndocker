GLIBC_VERSION=$1
mkdir -p /glibc/$GLIBC_VERSION
cd /ctf/work
wget http://mirrors.ustc.edu.cn/gnu/libc/glibc-${GLIBC_VERSION}.tar.gz
tar xf glibc-${GLIBC_VERSION}.tar.gz
cd glibc-${GLIBC_VERSION}
mkdir build
cd build
../configure --prefix=/glibc/${GLIBC_VERSION}/ --disable-werror --enable-debug=yes
make
make install
cd ../../
rm -rf glibc-${GLIBC_VERSION} && rm glibc-${GLIBC_VERSION}.tar.gz
