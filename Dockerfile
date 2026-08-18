FROM gentoo/stage3:amd64-desktop-systemd
RUN emerge-webrsync

COPY make.conf /etc/portage/make.conf

RUN emerge curl dev-vcs/git vim openmp
# openmp compiler-rt compiler-rt-sanitizers cmake llvm-core/clang llvm-core/llvm
# pillow
RUN eselect profile set default/linux/amd64/23.0/desktop/gnome/systemd \
  || eselect profile set default/linux/arm64/23.0/desktop/gnome/systemd \
  || eselect profile set default/linux/riscv/23.0/rv64/lp64d/desktop/systemd

# x32 support
RUN emerge boehm-gc libatomic_ops libxcrypt
# some USE flags clashes for gnome
RUN USE=gnutls emerge ngtcp2
# unsupported linker-script syntax: INSERT AFTER:
# https://github.com/smuellerDD/leancrypto/blob/939384e848f0de7cbcb66ea0d30b9fa08305983c/internal/src/fips_integrity_check.ld#L4
RUN emerge leancrypto

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root

RUN git clone https://github.com/davidlattimore/wild.git
WORKDIR /root/wild
RUN git rev-parse --short HEAD
RUN cargo b -r
RUN cp target/release/wild /usr/sbin/ld
RUN cp target/release/wild /usr/sbin/wild
RUN ld --version
COPY .bash_history /root/.bash_history

# emerge world - ~300 packages
# emerge gnome - ~400 packages
# emerge texlive neovim gimp kcachegrind libreoffice gimp inkscape - ~250 packages

# TODO:

# Known limitations:
#
# - lapack - unresolved symbol in configure checking
# - texlive-core - checking whether float word ordering is bigendian - symbol is removed due to GC (--no-gc-sections helps)

# Random package build issues:
# - ghc: uses --relocatable (-r) option
# - satisfier: uses -oformat
