X= ; cp /usr/sbin/*-pc-linux-gnu-ld.bfd /usr/sbin/ld && emerge $X && cp /usr/sbin/wild /usr/sbin/ld
emerge texlive neovim gimp kcachegrind libreoffice gimp inkscape
USE="server screencast gdk-pixbuf" emerge gnome
emerge --emptytree @installed -a
emerge --update --deep --newuse @world
