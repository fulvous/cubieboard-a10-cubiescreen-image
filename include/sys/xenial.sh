
PAQUETES_DB="${PAQUETES_DB},wpasupplicant,wireless-tools,i2c-tools,python3"

if [ "${DEBOOTSTRAP_G}" == "1" ] ; then
  PAQUETES_DB="${PAQUETES_DB},gnome-desktop,glibgdk-pixbuf2.0-dev,pixmap,network-manager-gnome,gtk2-engines-pixbuf,ruby-gdk-pixbuf2"
  debug "Agregando gnome a paquetes: ${PAQUETES_DB}"
fi

function sources {
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/etc/apt/sources.list
deb http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO} main restricted multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO} main restricted multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-updates main restricted multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-updates main restricted multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO} universe
deb-src http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO} universe
deb http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-updates universe
deb-src http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-updates universe
deb http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-security main restricted multiverse
deb-src http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-security main restricted multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-security universe
deb-src http://ports.ubuntu.com/ubuntu-ports/ ${DISTRO}-security universe
EOT
}

function desktop_firstboot {
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin/inicial.sh
#!/bin/bash

if [ -f /usr/local/bin/primera ] ; then
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
