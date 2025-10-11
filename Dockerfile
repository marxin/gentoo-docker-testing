FROM docker.io/gentoo/stage3
RUN emerge-webrsync

# binary large packages + essential dependencies
RUN FEATURES='getbinpkg binpkg-request-signature' emerge curl dev-vcs/git pillow vim openmp compiler-rt compiler-rt-sanitizers cmake llvm-core/clang llvm-core/llvm
RUN eselect profile set default/linux/amd64/23.0/desktop/gnome/systemd

# x32 support
RUN emerge boehm-gc libatomic_ops libxcrypt

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root

RUN echo invalidatedaaa > /tmp/invalidated.txt
RUN git clone https://github.com/davidlattimore/wild.git && echo Yay
WORKDIR /root/wild
RUN git rev-parse --short HEAD
RUN cargo b -r
RUN cp target/release/wild /usr/sbin/ld
RUN cp target/release/wild /usr/sbin/wild
RUN ld --version
RUN echo 'USE="-gdk-pixbuf -sysprof fontconfig webp minizip"' >> /etc/portage/make.conf
RUN echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf
RUN echo 'ACCEPT_KEYWORDS="~arm64"' >> /etc/portage/make.conf
COPY .bash_history /root/.bash_history

# emerge world - ~300 packages
# emerge gnome - ~400 packages
# emerge texlive neovim gimp kcachegrind libreoffice gimp inkscape - ~250 packages

# Known limitations:
#
# - spidermonkey: cannot find adequate linker
# - NetworkManager: pending `nm -D` change by Mateusz (will be fixed in the upcoming release)
# - lapack - unresolved symbol in configure checking
# - texlive-core - checking whether float word ordering is bigendian - symbol is removed due to GC (--no-gc-sections helps)

# Random package build issues:
# - audiofile: missing --retain-symbols-file option (latest relase is 10+ years old)
# - ghc: uses --relocatable (-r) option
# - satisfier: uses -oformat
# - efivar: --no-fatal-warnings: support
