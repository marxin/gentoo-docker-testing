FROM docker.io/gentoo/stage3
RUN emerge-webrsync

# binary large packages + essential dependencies
RUN FEATURES='getbinpkg binpkg-request-signature' emerge curl dev-vcs/git pillow vim openmp compiler-rt compiler-rt-sanitizers cmake
RUN emerge llvm-core/clang llvm-core/llvm
RUN eselect profile set default/linux/amd64/23.0/desktop/gnome/systemd

# Fix broken strip: https://sourceware.org/bugzilla/show_bug.cgi?id=33119
RUN cp /usr/lib/llvm/20/bin/llvm-strip /usr/x86_64-pc-linux-gnu/binutils-bin/2.44/strip

# x32 support
RUN emerge boehm-gc libatomic_ops libxcrypt

# undefined symbols
RUN emerge alsa-lib libpciaccess mkfontscale elfutils

# binary: undefined symbol
RUN emerge cups

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root

# RUN git clone https://github.com/davidlattimore/wild.git
RUN git clone https://github.com/marxin/wild.git
WORKDIR /root/wild
RUN git checkout gentoo
RUN cargo b -r
RUN cp target/release/wild /usr/sbin/ld
RUN cp target/release/wild /usr/sbin/wild
RUN ld --version
COPY .bash_history /root/.bash_history

# TODO: gtk+
# TODO: qtbase: --dynamic-list

# https://github.com/pulseaudio/pulseaudio/blob/98c7c9eafb148c6e66e5fe178fc156b00f3bf51a/src/modules/echo-cancel/meson.build#L19
# TODO: pulseaudio-daemon: --unresolved-symbols=ignore-in-object-files

### GNOME ###
# undefined: giflib

# slang: -R (--just-symbols)

# https://github.com/google/highway/blob/0e759dd39119644c902eb0dcda2cfe03483c40ac/hwy/hwy.version#L4
