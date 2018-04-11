

PAQUETES_DB="${PAQUETES_DB},wpasupplicant,wireless-tools,i2c-tools"

if [ "${DEBOOTSTRAP_G}" == "1" ] ; then
  PAQUETES_DB="${PAQUETES_DB},task-lxde-desktop,openbox-themes,gnome-icon-theme,libgdk-pixbuf2.0-dev,pixmap,network-manager-gnome,gtk2-engines-pixbuf,ruby-gdk-pixbuf2"
  debug "Agregando lxde a paquetes: ${PAQUETES_DB}"
fi

function sources {
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/etc/apt/sources.list
deb http://http.debian.net/debian $DISTRO main contrib non-free
deb-src http://http.debian.net/debian $DISTRO main contrib non-free
deb http://http.debian.net/debian $DISTRO-updates main contrib non-free
deb-src http://http.debian.net/debian $DISTRO-updates main contrib non-free
deb http://security.debian.org/debian-security $DISTRO/updates main contrib non-free
deb-src http://security.debian.org/debian-security $DISTRO/updates main contrib non-free
EOT
}

function desktop_firstboot {
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin/inicial.sh
#!/bin/bash

if [ -f /usr/local/bin/primera ] ; then
        /usr/lib/arm-linux-gnueabihf/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders > /usr/lib/arm-linux-gnueabihf/gdk-pixbuf-2.0/2.10.0/loaders.cache
        echo ",+" | sfdisk -N 2 /dev/mmcblk0 --force --no-reread
        rm /usr/local/bin/primera
        touch /usr/local/bin/segunda
        reboot
else 
        if [ -f /usr/local/bin/segunda ] ; then 
                rm /usr/local/bin/segunda
                resize2fs /dev/mmcblk0p2
        fi
fi

## rm /usr/local/bin/inicial.sh
EOT

        ##Dar permiso de ejecución a primer arranque
        chmod 755 ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin/inicial.sh
}
