function debootstrap {
  if [ ! -d ${DEBOOTSTRAP_F} ] ; then
    debug "No existe la carpeta ${DEBOOTSTRAP_F} generandola..."
    mkdir ${PWD_F}/${DEBOOTSTRAP_F}
    debug "Marcando debootstrap para su creacion"
    DEBOOTSTRAP_C=1
  fi

  if [ "${DEBOOTSTRAP_C}" == "1" ] ; then
    informa "Creando imagen" "Debootstrap" "${DEBOOTSTRAP_I}"
    if [ ! -f ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}.${DEBOOTSTRAP_EXT} ] ; then
      debug "No existe imagen debootstrap, hay que crearla"
      [ -d ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I} ] && \
        informa "Borrando directorio incompleto" \
          ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I} && \
        rm -Rf ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}
      debug "Creando el directorio ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}"
      mkdir ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}

      ##Colocando los locales
      debug "Colocando los locales en debootstrap"
      mkdir -p ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}/etc/default
cat <<EOT > ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}/etc/locale.gen
${LOCALES}
EOT

cat <<EOT > ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}/etc/default/locale
LANG=${LOCAL}
LC_TYPE=${LOCAL}
LC_MESSAGES=${LOCAL}
LC_ALL=${LOCAL}
LANGUAGE=${LENGUAJE}
EOT

      informa "Descargando" "paquetes" "${DISTRO}"

      debug "Corriendo el debootstrap"
      debootstrap --include="${PAQUETES_DB}" \
      --arch=armhf \
      --foreign ${DISTRO} \
      ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}

      cp /usr/bin/qemu-arm-static \
        ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}/usr/bin
      chroot ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I} \
        /usr/bin/qemu-arm-static /bin/sh \
        -i /debootstrap/debootstrap --second-stage
      informa "Comprimiendo debootstrap" "${DISTRO}" "${DEBOOTSTRAP_I}.${DEBOOTSTRAP_EXT}"
      cd ${PWD_F}/${DEBOOTSTRAP_F}
      tar cf - ${DEBOOTSTRAP_I} | \
        pigz -9 > ${DEBOOTSTRAP_I}.${DEBOOTSTRAP_EXT}
      cd ${PWD_F}
      debug "Borrando el directorio de trabajo"
      rm -Rf ${PWD_F}/${DEBOOTSTRAP_F}/${DEBOOTSTRAP_I}
    else
      informa "Imagen" "${DEBOOTSTRAP_I}" "Encontrada"
    fi
    res_ok "Debootstrap" "creado" "Exitoso"
  fi
}
