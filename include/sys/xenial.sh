
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
