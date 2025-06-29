X= ; cp /usr/sbin/x86_64-pc-linux-gnu-ld.bfd /usr/sbin/ld && emerge $X && cp /usr/sbin/wild /usr/sbin/ld
USE="-gdk-pixbuf -sysprof" emerge --update --deep --newuse @world
emerge --update --deep --newuse gnome
