function compila {
  #Compilando sunxi-tools
  if [ ! -f ${PWD_F}/${SUNXITOOLS_F}/fex2bin ] ; then
    informa "Compilando" "sunxi-tools"
    debug "Compilando sunxi-tools"
    cd ${PWD_F}/${SUNXITOOLS_F}
    make && make install
    cd ${PWD_F}
    informa "Sunxi-tools" "instalados"
  fi
  
  #Compilando u-boot
  if [ "${UBOOT_C}" == "1" ] ; then
    informa "Configurando" "u-boot" "${TARJETA}_config"
    cd ${PWD_F}/${UBOOT_F}
    make -j$(nproc) CROSS_COMPILE=arm-linux-gnueabihf- ${TARJETA}_config
    informa "Compilando" "u-boot" "${TARJETA}"
    make -j$(nproc) CROSS_COMPILE=arm-linux-gnueabihf-
    informa "Generando" "script.bin" "${TARJETA}"
    cd ${PWD_F}
    [ ! -d ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V} ] && \
      mkdir -p ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}
    fex2bin ${PWD_F}/sources/fex/script.fex \
    ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}/script.bin
    informa "Creando" "boot.scr"
    mkimage -C none -A arm -T script -d ${PWD_F}/sources/boot/boot.cmd \
    ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}/boot.scr
    cp -v ${PWD_F}/sources/boot/uEnv.txt \
    ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}/uEnv.txt
    res_ok "Compilacion de" "u-boot-${UBOOT_V}" "Exitoso"
  fi

  #Configuración y compilado del kernel
  if [ "${KERNEL_C}" == "1" ] ; then
  
    informa "Configurando" "kernel" "${KERNEL_V}"
  
    cd ${PWD_F}/${KERNEL_F}
  
    make -j$(nproc) ARCH=arm \
    CROSS_COMPILE=arm-linux-gnueabihf- \
    ${CONFIG_TARJETA}
  
    if [ "${KERNEL_M}" == "1" ] ; then
      make -j$(nproc) ARCH=arm \
      CROSS_COMPILE=arm-linux-gnueabihf- \
      menuconfig
    fi
    
  
    if [ "${KERNEL_P}" == "1" ] ; then
      informa "Ejecutando" "kernel" "patch.sh"
      cd ${PWD_F}
      [ ! -d ${PWD_F}/${TMP_F} ] && \
        mkdir -p ${PWD_F}/${TMP_F}
      source include/patch.sh
      sleep 3
    fi
  
    informa "Compilando" "kernel" "${KERNEL_V}"
  
    cd ${PWD_F}/${KERNEL_F}
  
    make -j$(nproc) ARCH=arm \
    CROSS_COMPILE=arm-linux-gnueabihf- \
    uImage modules
  
    informa "Instalando" "modulos" "${KERNEL_V}"
  
    [ ! -d ${PWD_F}/${DEBOOTSTRAP_F}/${KERNEL_V} ] && \
      mkdir -p ${PWD_F}/${DEBOOTSTRAP_F}/${KERNEL_V}
  
    make ARCH=arm \
    CROSS_COMPILE=arm-linux-gnueabihf- \
    INSTALL_MOD_PATH=${PWD_F}/${DEBOOTSTRAP_F}/${KERNEL_V} \
    modules_install
    
    cd ${PWD_F}
  
    res_ok "Compilacion" "kernel-${KERNEL_V}" "Exitoso"
  fi
  
  jumbotron "Proceso de compilación terminado" \
    "Continuando con creación de imagen" \
    "Se descargara el sistema de archivos si no existe"
}

