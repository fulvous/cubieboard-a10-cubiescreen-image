function crear_imagen {  
 informa "Creando" "archivo" "temporal"
  dd if=/dev/zero \
    of=${PWD_F}/${TMP_F}/${IMAGEN} \
    bs=1G count=${SIZE_G}
  res_ok "Archivo" "${PWD_F}/${TMP_F}/${IMAGEN}" "Exitoso"

  #Creando dispositivo loop
  debug "Asignando loop"
  LOOP="$(losetup -f)"
  informa "Asignando" "loop" "${LOOP}"
  losetup ${LOOP} ${PWD_F}/${TMP_F}/${IMAGEN}

  #Instalando boot
  informa "Instalando" "u-boot"
  dd if=${PWD_F}/${UBOOT_F}/u-boot-sunxi-with-spl.bin \
    of=${LOOP} \
    bs=1024 \
    seek=8
  res_ok "U-boot" "instalado" "Exitoso"

  #Particionando loop
  informa "Particionando" "${LOOP}"
  sfdisk -R ${LOOP}
cat <<EOT | sfdisk --in-order -L -uM ${LOOP}
1,16,c
,,L
EOT
  res_ok "Dispositivo" "particionado" "Exitoso"

  #Desinstalando loop
  informa "Desmontando" "loop" "${LOOP}"
  losetup -d ${LOOP}
  res_ok "Loop" "desmontado" "Exitoso"
}
