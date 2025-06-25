FROM docker.io/gentoo/stage3
RUN emerge-webrsync
# static-libs
RUN echo 'USE="X ssl elogind -systemd corefonts truetype jpeg jpeg2k tiff zstd binary -perl"' >> /etc/portage/make.conf && \
    echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf && \
    echo 'ACCEPT_LICENSE="* -@EULA"' >> /etc/portage/make.conf && \
#    echo 'FEATURES="\${FEATURE} noclean nostrip ccache -ipc-sandbox -network-sandbox -pid-sandbox -sandbox"' >> /etc/portage/make.conf && \
    echo 'CCACHE_DIR="/ccache"' >> /etc/portage/make.conf
RUN emerge curl dev-vcs/git mold

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root
RUN git clone https://github.com/davidlattimore/wild.git
WORKDIR /root/wild
RUN cargo b -r
RUN cp target/release/wild /usr/sbin/ld
RUN ld --version
