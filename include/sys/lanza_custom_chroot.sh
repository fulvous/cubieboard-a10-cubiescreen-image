function lanza_custom_chroot {
  #Ejecutando los scripts custom-chroot
  informa "Ejecutando" "include/custom-chroot.sh"
  debug "Copiando los scripts a la imagen"
  cp -v ${PWD_F}/herramientax/formato/colores.sh \
    ${PWD_F}/${TMP_F}/${MNT}
  cp -v ${PWD_F}/include/custom-chroot.sh \
    ${PWD_F}/${TMP_F}/${MNT}

  debug "Ejecutando el script en jaula"
  chroot ${PWD_F}/${TMP_F}/${MNT} \
    /usr/bin/qemu-arm-static /bin/bash \
    /custom-chroot.sh

  debug "Borrando los scripts de la imagen"
  rm ${PWD_F}/${TMP_F}/${MNT}/custom-chroot.sh
  rm ${PWD_F}/${TMP_F}/${MNT}/colores.sh

  res_ok "Script" "include/custom.sh" "Exitoso"
}
