#Cubiecopiadora realiza imagenes para memoria SD para cubieboard A10
#Copyright (C) 2017 Leon Ramos @fulvous
#
#Este archivo es parte de Cubiecopiadora
#
#Cubiecopiadora es software libre: Puede redistribuirlo y/o 
#modificarlo bajo los terminos de la Licencia de uso publico 
#general GNU de la Fundacion de software libre, ya sea la
#version 3 o superior de la licencia.
#
#Cubiecopiadora es distribuida con la esperanza de que sera util,
#pero sin ningun tipo de garantia; inclusive sin la garantia
#implicita de comercializacion o para un uso particular.
#Vea la licencia de uso publico general GNU para mas detalles.
#
#Deberia de recibir uan copia de la licencia de uso publico
#general junto con Cubiecopiadora, de lo contrario, vea
#<http://www.gnu.org/licenses/>.
#
#This file is part of Cubiecopiadora
#
#Cubiecopiadora is free software: you can redistribute it and/or 
#modify it under the terms of the GNU General Public License 
#as published by the Free Software Foundation, either version 3 
#of the License, or any later version.
#
#Cubiecopiadora is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with Cubiecopiadora  If not, see 
#<http://www.gnu.org/licenses/>.

#!/bin/bash

source include/colores.sh

CLONE="false"
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
[ ! -d ${PWD_F}/${OUTPUT_F} ] && mkdir ${PWD_F}/${OUTPUT_F}

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
[ ! -d ${PWD_F}/${OUTPUT_F}/boot ] && mkdir ${PWD_F}/${OUTPUT_F}/boot
fex2bin sources/fex/cubieboard-a10-cubiescreen.fex ${OUTPUT_F}/boot/script.bin

#Configuring kernel
echo "${bold}Configurando Kernel ${yellow}${KERNEL_V}${reset}" 
cd ${PWD_F}/linux-sunxi
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- ${TARGET_KERNEL}

#Patching Kernel and adding modules
echo "${bold}Parchando el Kernel ${yellow}Cubiescreen${reset}" 
cd ${PWD_F}
[ ! -d ${PWD_F}/${TMP_F} ] && mkdir -p ${PWD_F}/${TMP_F}
tar xvf sources/cubiescreen/cubiescreen_drv.tar \
   -C ${PWD_F}/${TMP_F}

cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/touchscreen/* \
  ${PWD_F}/${KERNEL_F}/drivers/input/touchscreen/
cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/video/disp/* \
  ${PWD_F}/${KERNEL_F}/drivers/video/sunxi/disp/
cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/video/lcd/* \
  ${PWD_F}/${KERNEL_F}/drivers/video/sunxi/lcd/
cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/ctp.h \
  ${PWD_F}/${KERNEL_F}/include/linux/

sleep 5

#Building kernel
echo "${bold}Compilando Kernel ${yellow}${KERNEL_V}${reset}" 
cd ${PWD_F}/linux-sunxi
make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage modules

#Building modules
echo "${bold}Compilando Modulos ${yellow}${KERNEL_V}${reset}" 
cd ${PWD_F}/linux-sunxi
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=output modules_install
