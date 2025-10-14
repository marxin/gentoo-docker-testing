X= ; cp /usr/sbin/*-pc-linux-gnu-ld.bfd /usr/sbin/ld && emerge $X && cp /usr/sbin/wild /usr/sbin/ld
emerge texlive neovim gimp kcachegrind libreoffice gimp inkscape
emerge --update --deep --newuse gnome
USE="-webp -harfbuzz" emerge --update --deep --newuse @world
