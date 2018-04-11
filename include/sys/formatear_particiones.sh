function formatear_particiones {
  #Montando con kpartx
  informa "Montando con" "kpartx" "${TMP_F}/${IMAGEN}"
  KPARTX_M=1
  parts=($(kpartx -l ${PWD_F}/${TMP_F}/${IMAGEN} | egrep -o "loop[0-9]{1,2}p[0-9]{1,2}"))
  kpartx -av ${PWD_F}/${TMP_F}/${IMAGEN}

  #Formateando particiones
  informa "Formateando" "particion" "${parts[0]}"
  mkfs.vfat /dev/mapper/${parts[0]}
  res_ok "Particionada" "${parts[0]}" "Exitoso"
  informa "Formateando" "particion" "${parts[1]}"
  mkfs.ext4 /dev/mapper/${parts[1]}
  res_ok "Particionada" "${parts[1]}" "Exitoso"
}
