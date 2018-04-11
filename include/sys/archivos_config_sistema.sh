function archivos_config_sistema {
  #Agregando entradas a fstab
  informa "Agregando" "/etc/fstab"
cat <<EOT >> ${PWD_F}/${TMP_F}/${MNT}/etc/fstab
none  /tmp  tmpfs defaults,noatime,mode=1777 0 0
/dev/mmcblk0p1 /boot vfat  defaults  0 0
EOT
  res_ok "Archivo cambiado" "/etc/fstab" "Exitoso"

  #Agregando archivo de interfaces
  informa "Agregando" "/etc/network/interfaces"
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/etc/network/interfaces
auto lo
iface lo inet loopback
allow-hotplug eth0
iface eth0 inet dhcp
iface wlan0 inet dhcp
EOT
  res_ok "Archivo creado" "/etc/network/interfaces" "Exitoso"

  #Agregando archivo resolv.conf
  informa "Agregando" "/etc/resolv.conf"
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/etc/resolv.conf
nameserver 8.8.8.8
nameserver 4.2.2.2
EOT
  res_ok "Archivo creado" "/etc/resolv.conf" "Exitoso"

  #Evitar actualizaciones automaticas
  informa "Evitar actualizaciones" "automaticas"
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOT
  res_ok "Actualizaciones automaticas" "/etc/apt/apt.conf.d/71-no-recommends" "Exitoso"

  #Asegurarnos de tener terminal serial
  informa "Habilitar" "terminal serial"
  echo "T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100" >> ${PWD_F}/${TMP_F}/${MNT}/etc/inittab

}
