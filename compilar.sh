#!/bin/bash

source include/colors.sh

CLONE="true"
TARGET="Cubieboard"
TARGET_KERNEL="sun4i_defconfig"
PWD_F="$(pwd)"
OUTPUT_F="output"
KERNEL_V="3.4.79"
KERNEL_F="linux-sunxi"
TMP_F="tmp"

#Getting u-boot
echo "${bold}Descargando u-boot ${yellow}u-boot-sunxi.git${reset}" 
cd ${PWD_F}
[ "$CLONE" == "true" ] && git clone -b sunxi https://github.com/linux-sunxi/u-boot-sunxi.git

#Getting kernel
echo "${bold}Descargando kernel ${yellow}linux-sunxi.git${reset}" 
cd ${PWD_F}
[ "$CLONE" == "true" ] && git clone -b sunxi-${KERNEL_V} https://github.com/linux-sunxi/linux-sunxi.git

#Checking output folder
echo "${bold}Checando folder ${yellow}${OUTPUT_F}${reset}" 
cd ${PWD_F}
[ ! -d ${OUTPUT_F} ] && mkdir ${PWD_F}/${OUTPUT_F}

#Configure u-boot
cd ${PWD_F}/u-boot-sunxi
echo "${bold}Configurando u-boot ${yellow}${TARGET}${reset}" 
make CROSS_COMPILE=arm-linux-gnueabihf- ${TARGET}_config

#Compile u-boot
echo "${bold}Compilando u-boot ${yellow}${TARGET}${reset}" 
make CROSS_COMPILE=arm-linux-gnueabihf-

#Make fex file
echo "${bold}Creando ${yellow}script.bin${reset}" 
cd ${PWD_F}
fex2bin sources/fex/cubieboard-a10-cubiescreen.fex ${OUTPUT_F}/script.bin

#Configuring kernel
echo "${bold}Configurando Kernel ${yellow}${KERNEL_V}${reset}" 
cd ${PWD_F}/linux-sunxi
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ${TARGET_KERNEL}

#Patching Kernel and adding modules
echo "${bold}Parchando el Kernel ${yellow}Cubiescreen${reset}" 
cd ${PWD_F}
[ ! -d ${PWD_F}/${TMP_F} ] && mkdir -p ${PWD_F}/${TMP_F}
cp ${PWD_F}/${TMP_F}/cubiescreen/driver/touchscreen/* ${PWD_F}/${KERNEL_F}/drivers/input/touchscreen/
cp ${PWD_F}/${TMP_F}/cubiescreen/driver/video/disp/* ${PWD_F}/${KERNEL_F}/drivers/video/sunxi/disp/
cp ${PWD_F}/${TMP_F}/cubiescreen/driver/video/lcd/* ${PWD_F}/${KERNEL_F}/drivers/video/sunxi/lcd/
cp ${PWD_F}/${TMP_F}/cubiescreen/driver/ctp.h ${PWD_F}/${KERNEL_F}/include/linux/


#Building kernel
echo "${bold}Compilando Kernel ${yellow}${KERNEL_V}${reset}" 
cd ${PWD_F}/linux-sunxi
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage modules

#Building modules
echo "${bold}Compilando Modulos ${yellow}${KERNEL_V}${reset}" 
cd ${PWD_F}/linux-sunxi
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=output modules_install
