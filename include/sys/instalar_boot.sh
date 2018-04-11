function instalar_boot {
  #Copiando particion boot
  informa "Copiando" "particion" "boot"
  if [ ! -d ${PWD_F}/${TMP_F}/${MNT} ] ; then
    debug "No existe la carpeta boot, creandola"
    mkdir -p ${PWD_F}/${TMP_F}/${MNT}
  fi
  mount /dev/mapper/${parts[0]} ${PWD_F}/${TMP_F}/${MNT}
  cp -v ${PWD_F}/${KERNEL_F}/arch/arm/boot/uImage \
    ${PWD_F}/${TMP_F}/${MNT}
  [ ! -d ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V} ] && \
    mkdir -p ${PWD_F}/${DEBOOTSTRAP_F}
  cp -v ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}/script.bin \
    ${PWD_F}/${TMP_F}/${MNT}
  cp -v ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}/boot.scr \
    ${PWD_F}/${TMP_F}/${MNT}
  cp -v ${PWD_F}/${DEBOOTSTRAP_F}/${UBOOT_V}/uEnv.txt \
    ${PWD_F}/${TMP_F}/${MNT}
  umount /dev/mapper/${parts[0]}
}
