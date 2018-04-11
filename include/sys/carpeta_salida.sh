function carpeta_salida {
  #Moviendo la imagen a la carpeta de salida
  if [ ! -d ${PWD_F}/${SALIDA_F} ] ; then
    informa "Creando la carpeta de salida" "${PWD_F}/${SALIDA_F}"
    mkdir -p ${PWD_F}/${SALIDA_F}
  fi
  informa "Moviendo imagen de folder temporal a" "salida"
  mv -v ${PWD_F}/${TMP_F}/${IMAGEN}  \
    ${PWD_F}/${SALIDA_F}
  res_ok "Imagen ${IMAGEN} copiada a" "${PWD_F}/${SALIDA_F}" "Exitoso"
}
