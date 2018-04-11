function prepara_folders {
  #Preparando folders temporales y de salida
  informa "Validando" "folders" "${OUTPUT_F} ${TMP_F}"
  for folder in "${OUTPUT_F} ${TMP_f}"; do
    [ ! -d ${PWD_F}/${folder} ] && \
    debug "Creando folder ${PWD_F}/${folder}" && \
    mkdir ${PWD_F}/${folder}
  done
  rm -Rfv ${PWD_F}/${TMP_F}/*
  res_ok "Folders existentes" "${OUTPUT_F} ${TMP_F}" "Exitoso"
}
