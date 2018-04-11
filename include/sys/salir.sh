#Trap de salida
function salir {
  #Desmontando systemas de archivos
  sleep 3
  if [ ${VIRTUALES_M} -gt 0 ] ; then
    debug "Desmontando sistemas virtuales"
    umount ${PWD_F}/${TMP_F}/${MNT}/dev/pts
    for i in proc dev sys; do
      umount ${PWD_F}/${TMP_F}/${MNT}/$i
    done
    sleep 3
    umount /dev/mapper/${parts[1]}
  fi

  if [ ${KPARTX_M} -gt 0 ] ; then
    #Desmontando con kpartx
    debug "Desmontando particiones loop"
    kpartx -d ${PWD_F}/${TMP_F}/${IMAGEN}
    res_ok "Particion desmontada" "${PWD_F}/${TMP_F}/${IMAGEN}" "Exitoso"
  fi
}

