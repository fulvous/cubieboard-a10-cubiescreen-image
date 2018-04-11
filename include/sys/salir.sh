#Trap de salida
function salir {
  #Desmontando systemas de archivos
  sleep 3
  debug "Desmontando sistemas virtuales"
  umount ${PWD_F}/${TMP_F}/${MNT}/dev/pts
  for i in proc dev sys; do
    umount ${PWD_F}/${TMP_F}/${MNT}/$i
  done
  sleep 3
  umount /dev/mapper/${parts[1]}

}
trap salir EXIT

