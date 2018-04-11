function borrar_temps {
  #Borrar carpetas
  if [ "${BORRAR}" == "1" ] ; then
    informa "Borrando" "carpetas" "todas"
    for folder in ${FOLDERS} ; do
      if [ -d ${PWD_F}/${folder} ] ; then
        debug "Borrando ${PWD_F}/$folder"
        rm -Rf ${PWD_F}/${folder}
      fi
    done
    res_ok "Carpetas borradas" "todas" "Exitoso"
    debug "Activando compilacion de u-boot y kernel"
    UBOOT_C=1
    KERNEL_C=1
  fi
}

