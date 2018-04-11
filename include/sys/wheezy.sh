

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
