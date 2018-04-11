function descarga {
  #Descargando sunxi-tools
  if [ ! -d ${SUNXITOOLS_F} ] ; then
    informa "Descargando" "sunxi-tools"
    git clone https://github.com/linux-sunxi/sunxi-tools ${SUNXITOOLS_F}
    res_ok "Descarga" "sunxi-tools" "Exitoso"
  else
    informa "Actualizando" "sunxi-tools"
    cd ${SUNXITOOLS_F}
    git pull
    cd ${PWD_F}
  fi
  
  
  #Descargando u-boot
  if [ ! -d ${UBOOT_F} ] ; then
    informa "Descargando" "u-boot" "${UBOOT_V}"
    git clone -b ${UBOOT_V} https://github.com/linux-sunxi/u-boot-sunxi.git ${UBOOT_F}
    res_ok "Descarga" "u-boot-${UBOOT_V}" "Exitoso"
  else
    informa "Actualizando" "u-boot" "${UBOOT_V}"
    cd ${UBOOT_F}
    git pull
    cd ${PWD_F}
  fi
  
  #Descargando kernel
  if [ ! -d ${KERNEL_F} ] ; then
    informa "Descargando" "kernel" "${KERNEL_V}"
    git clone -b sunxi-${KERNEL_V} https://github.com/linux-sunxi/linux-sunxi.git ${KERNEL_F}
    res_ok "Descarga" "kernel-${KERNEL_V}" "Exitoso"
  else
    informa "Actualizando" "kernel" "${KERNEL_V}"
    cd ${KERNEL_F}
    git reset --hard
    git pull https://github.com/linux-sunxi/linux-sunxi.git
    cd ${PWD_F}
  fi
}
