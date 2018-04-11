function actualizar {
  #Montando fs virtuales
  informa "Montando carpetas" "proc dev dev/pts sys"
  for i in proc dev sys; do
    mount -o bind /$i ${PWD_F}/${TMP_F}/${MNT}/$i
  done
  mount -o bind /dev/pts ${PWD_F}/${TMP_F}/${MNT}/dev/pts
  VIRTUALES_M=1
  res_ok "Carpetas montadas" "proc dev dev/pts sys" "Exitoso"

  #Actualizar paquetes
  informa "Actualizando" "paquetes"
  debug "Creando tmp/update.sh"
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/tmp/update.sh
#!/bin/bash
apt-get install -f -y
apt-get update -y
apt-get upgrade -y
EOT
  debug "Ejecutando tmp/update.sh"
  chroot ${PWD_F}/${TMP_F}/${MNT} \
    /usr/bin/qemu-arm-static /bin/bash \
    /tmp/update.sh
  debug "Borrando archivo de actualizacion"
  rm ${PWD_F}/${TMP_F}/${MNT}/tmp/update.sh
  res_ok "Actualizacion de" "sistema" "Exitoso"
}
