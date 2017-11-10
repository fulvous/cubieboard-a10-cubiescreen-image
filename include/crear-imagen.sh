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

PWD_F="$(pwd)"
TMP_F="tmp"
TMP_DEV="image.raw"
MOUNT_R="mnt"
OUTPUT_F="output"
KERNEL_F="linux-sunxi"
DISTRO="wheezy"

#Installing needed packages
echo "${bold}Descargando ${yellow}paquetes${reset}"
sudo apt-get install kpartx \
  qemu binfmt-support qemu-user-static

#Checando directorio temporal
echo "${bold}Checando folder ${yellow}${TMP_F}${reset}"
[ ! -d ${PWD_F}/${TMP_F} ] && \
  mkdir -p ${PWD_F}/${TMP_F}
[ ! -f ${PWD_F}/${TMP_F}/${TMP_DEV} ] && \
  dd if=/dev/zero of=${PWD_F}/${TMP_F}/${TMP_DEV} bs=1G count=3

#Creado dispositivo virtual
FREE_LOOP="$(sudo losetup -f)"
echo "${bold}Asignando dispositivo loop ${yellow}${FREE_LOOP}${reset}"

#Asigna el dispositivo loop
sudo losetup ${FREE_LOOP} ${PWD_F}/${TMP_F}/${TMP_DEV}

#Instalando el boot
echo "${bold}Instalando ${yellow}u-boot${reset}"
sudo dd if=${PWD_F}/u-boot-sunxi/u-boot-sunxi-with-spl.bin \
  of=${FREE_LOOP} \
  bs=1024 \
  seek=8

#Particionando loop
echo "${bold}Particionando ${yellow}${FREE_LOOP}${reset}"
sudo sfdisk -R ${FREE_LOOP}
cat <<EOT | sudo sfdisk --in-order -L -uM ${FREE_LOOP}
1,16,c
,,L
EOT

#Desinstalando loop
echo "${bold}Desmontando loop ${yellow}${FREE_LOOP}${reset}"
sudo losetup -d ${FREE_LOOP}

#Montando con kpartx
echo "${bold}Montando con kpartx ${yellow}${TMP_F}/${TMP_DEV}${reset}"
declare -a parts=($(sudo kpartx -l ${PWD_F}/${TMP_F}/${TMP_DEV} \
   | egrep -o 'loop[0-9]{1,2}p[0-9]{1,2}'))
sudo kpartx -av ${PWD_F}/${TMP_F}/${TMP_DEV}

#Formateando particiones
echo "${bold}Formateando particiones ${yellow}${parts[0]}${reset}"
sudo mkfs.vfat /dev/mapper/${parts[0]}
echo "${bold}Formateando particiones ${yellow}${parts[1]}${reset}"
sudo mkfs.ext4 /dev/mapper/${parts[1]}

#Copiando particion boot
echo "${bold}Copiando ${yellow}Boot${reset}"
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R} ] && \
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R}/boot ] && \
  mkdir -p ${PWD_F}/${TMP_F}/${MOUNT_R}/boot 
sudo mount /dev/mapper/${parts[0]} ${PWD_F}/${TMP_F}/${MOUNT_R}/boot
sudo cp -v ${PWD_F}/${KERNEL_F}/arch/arm/boot/uImage \
  ${PWD_F}/${TMP_F}/${MOUNT_R}/boot
sudo cp -v ${PWD_F}/${OUTPUT_F}/boot/script.bin \
  ${PWD_F}/${TMP_F}/${MOUNT_R}/boot
sudo umount /dev/mapper/${parts[0]}

#Copiando particion root
echo "${bold}Copiando ${yellow}Root${reset}"
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R} ] && \
  mkdir -p ${PWD_F}/${TMP_F}/${MOUNT_R} 
sudo mount /dev/mapper/${parts[1]} ${PWD_F}/${TMP_F}/${MOUNT_R}
sudo debootstrap --arch=armhf --foreign ${DISTRO} \
  ${PWD_F}/${TMP_F}/${MOUNT_R}
sudo cp /usr/bin/qemu-arm-static \
  ${PWD_F}/${TMP_F}/${MOUNT_R}/usr/bin
sudo chroot ${PWD_F}/${TMP_F}/${MOUNT_R} \
  /usr/bin/qemu-arm-static /bin/sh \
  -i /debootstrap/debootstrap --second-stage

source include/custom.sh
#sudo umount /dev/mapper/${parts[1]}

##Desmontando particiones loop
#echo "${bold}Borrando loops ${yellow}${parts[@]}${reset}"
#sudo kpartx -d ${PWD_F}/${TMP_F}/${TMP_DEV}

