FROM docker.io/gentoo/stage3
RUN emerge-webrsync
# static-libs
#RUN echo 'USE="X ssl elogind -systemd corefonts truetype jpeg jpeg2k tiff zstd binary -perl"' >> /etc/portage/make.conf && \
#    echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf && \
#    echo 'ACCEPT_LICENSE="* -@EULA"' >> /etc/portage/make.conf && \
#    echo 'FEATURES="\${FEATURE} noclean nostrip ccache -ipc-sandbox -network-sandbox -pid-sandbox -sandbox"' >> /etc/portage/make.conf && \
#    echo 'CCACHE_DIR="/ccache"' >> /etc/portage/make.conf

RUN emerge curl dev-vcs/git pillow
RUN eselect profile set default/linux/amd64/23.0/desktop/gnome/systemd

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root
RUN git clone https://github.com/marxin/wild.git
WORKDIR /root/wild
RUN git checkout gentoo
RUN cargo b -r
RUN cp target/release/wild /usr/sbin/ld
RUN cp target/release/wild /usr/sbin/wild
RUN ld --version
COPY .bash_history /root/.bash_history
