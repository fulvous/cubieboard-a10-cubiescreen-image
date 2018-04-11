function instalar_root {
  #Copiando particion root
  informa "Copiando" "Root"
  mount /dev/mapper/${parts[1]} ${PWD_F}/${TMP_F}/${MNT}
  debug "Descomprimiendo con pigz"
  cd ${PWD_F}/${TMP_F}/${MNT}
  pigz -dc ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}.${DEBOOTSTRAP_EXT} \
    | tar xf - --strip 1
  cd ${PWD_F}
  res_ok "Archivos descomprimidos en" "root" "Exitoso"
  informa "Copiando" "modulos"
  if [ ! -d ${PWD_F}/${TMP_F}/${MNT}/lib/modules ] ; then
    debug "Creando directorio ${PWD_F}/${TMP_F}/${MNT}/lib/modules"
    mkdir -p ${PWD_F}/${TMP_F}/${MNT}/lib/modules
  fi
  cp -vr ${PWD_F}/${DEBOOTSTRAP_F}/${KERNEL_V}/lib ${PWD_F}/${TMP_F}/${MNT}
  res_ok "Copia de modulos" "${KERNEL_V}" "Exitoso"
}
