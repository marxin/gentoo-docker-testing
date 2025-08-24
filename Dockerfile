FROM docker.io/gentoo/stage3
RUN emerge-webrsync

# binary large packages + essential dependencies
RUN FEATURES='getbinpkg binpkg-request-signature' emerge curl dev-vcs/git pillow vim openmp compiler-rt compiler-rt-sanitizers cmake llvm-core/clang llvm-core/llvm
RUN eselect profile set default/linux/amd64/23.0/desktop/gnome/systemd

# x32 support
RUN emerge boehm-gc libatomic_ops libxcrypt

# undefined symbols - #968
RUN emerge alsa-lib elfutils

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root

RUN echo invalidatedaaa > /tmp/invalidated.txt
RUN git clone https://github.com/davidlattimore/wild.git && echo Yay
WORKDIR /root/wild
# RUN git checkout gentoo
RUN git rev-parse --short HEAD
RUN cargo b -r
RUN cp target/release/wild /usr/sbin/ld
RUN cp target/release/wild /usr/sbin/wild
RUN ld --version
COPY .bash_history /root/.bash_history

### GNOME ###

# TODO: gtk+ due to bad symbols in libbsd
# undefined: giflib lvm2 cryptsetup
# spidermonkey: cannot find adequate linker
# libbsd: broken symbol versioning
