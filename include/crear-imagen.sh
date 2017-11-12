#!/bin/bash

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

set -e

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
apt-get install kpartx \
  qemu binfmt-support qemu-user-static

#Checando directorio temporal
echo "${bold}Checando folder ${yellow}${TMP_F}${reset}"
[ ! -d ${PWD_F}/${TMP_F} ] && \
  mkdir -p ${PWD_F}/${TMP_F}
[ ! -f ${PWD_F}/${TMP_F}/${TMP_DEV} ] && \
  dd if=/dev/zero of=${PWD_F}/${TMP_F}/${TMP_DEV} bs=1G count=3

#Creado dispositivo virtual
FREE_LOOP="$(losetup -f)"
echo "${bold}Asignando dispositivo loop ${yellow}${FREE_LOOP}${reset}"

#Asigna el dispositivo loop
losetup ${FREE_LOOP} ${PWD_F}/${TMP_F}/${TMP_DEV}

#Instalando el boot
echo "${bold}Instalando ${yellow}u-boot${reset}"
dd if=${PWD_F}/u-boot-sunxi/u-boot-sunxi-with-spl.bin \
  of=${FREE_LOOP} \
  bs=1024 \
  seek=8

#Particionando loop
echo "${bold}Particionando ${yellow}${FREE_LOOP}${reset}"
sfdisk -R ${FREE_LOOP}
cat <<EOT | sfdisk --in-order -L -uM ${FREE_LOOP}
1,16,c
,,L
EOT

#Desinstalando loop
echo "${bold}Desmontando loop ${yellow}${FREE_LOOP}${reset}"
losetup -d ${FREE_LOOP}

#Montando con kpartx
echo "${bold}Montando con kpartx ${yellow}${TMP_F}/${TMP_DEV}${reset}"
parts=($(kpartx -l ${PWD_F}/${TMP_F}/${TMP_DEV} | egrep -o "loop[0-9]{1,2}p[0-9]{1,2}"))
kpartx -av ${PWD_F}/${TMP_F}/${TMP_DEV}

#Formateando particiones
echo "${bold}Formateando particiones ${yellow}${parts[0]}${reset}"
mkfs.vfat /dev/mapper/${parts[0]}
echo "${bold}Formateando particiones ${yellow}${parts[1]}${reset}"
mkfs.ext4 /dev/mapper/${parts[1]}

#Copiando particion boot
echo "${bold}Copiando ${yellow}Boot${reset}"
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R} ] && \
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R}/boot ] && \
  mkdir -p ${PWD_F}/${TMP_F}/${MOUNT_R}/boot 
mount /dev/mapper/${parts[0]} ${PWD_F}/${TMP_F}/${MOUNT_R}/boot
cp -v ${PWD_F}/${KERNEL_F}/arch/arm/boot/uImage \
  ${PWD_F}/${TMP_F}/${MOUNT_R}/boot
cp -v ${PWD_F}/${OUTPUT_F}/boot/script.bin \
  ${PWD_F}/${TMP_F}/${MOUNT_R}/boot
umount /dev/mapper/${parts[0]}

#Copiando particion root
echo "${bold}Copiando ${yellow}Root${reset}"
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R} ] && \
  mkdir -p ${PWD_F}/${TMP_F}/${MOUNT_R} 
mount /dev/mapper/${parts[1]} ${PWD_F}/${TMP_F}/${MOUNT_R}
debootstrap --arch=armhf --foreign ${DISTRO} \
  ${PWD_F}/${TMP_F}/${MOUNT_R}
cp /usr/bin/qemu-arm-static \
  ${PWD_F}/${TMP_F}/${MOUNT_R}/usr/bin
chroot ${PWD_F}/${TMP_F}/${MOUNT_R} \
  /usr/bin/qemu-arm-static /bin/sh \
  -i /debootstrap/debootstrap --second-stage

echo "${bold}Copiando los ${yellow}modulos${reset}"
[ ! -d ${PWD_F}/${TMP_F}/${MOUNT_R}/lib/modules ] && \
  mkdir -p ${PWD_F}/${TMP_F}/${MOUNT_R}/lib/modules
cp -vr ${PWD_F}/${KERNEL_F}/output/lib ${PWD_F}/${TMP_F}/${MOUNT_R}

echo "${bold}Agregando ${yellow}sources.list${reset}"
cat <<EOT > ${PWD_F}/${TMP_F}/${MOUNT_R}/etc/apt/sources.list
deb http://http.debian.net/debian $DISTRO main contrib non-free
deb-src http://http.debian.net/debian $DISTRO main contrib non-free
deb http://http.debian.net/debian $DISTRO-updates main contrib non-free
deb-src http://http.debian.net/debian $DISTRO-updates main contrib non-free
deb http://security.debian.org/debian-security $DISTRO/updates main contrib non-free
deb-src http://security.debian.org/debian-security $DISTRO/updates main contrib non-free
EOT

echo "${bold}Agregando archivos de ${yellow}sistema${reset}"
cat <<EOT >> ${PWD_F}/${TMP_F}/${MOUNT_R}/etc/fstab
none  /tmp  tmpfs defaults,noatime,mode=1777 0 0
/dev/mmcblk0p1 /boot vfat  defaults  0 0
EOT

cat <<EOT > ${PWD_F}/${TMP_F}/${MOUNT_R}/etc/network/interfaces
auto lo
iface lo inet loopback
allow-hotplug eth0
iface eth0 inet dhcp
EOT

cat <<EOT > ${PWD_F}/${TMP_F}/${MOUNT_R}/etc/resolv.conf
nameserver 8.8.8.8
nameserver 4.2.2.2
EOT

echo "${bold}Montando carpetas ${yellow}proc dev sys${reset}"
for i in proc dev sys; do 
  mount -o bind /$i ${PWD_F}/${TMP_F}/${MOUNT_R}/$i
done
mount -o bind /dev/pts ${PWD_F}/${TMP_F}/${MOUNT_R}/dev/pts


#Actualizar paquetes
echo "${bold}Actualizando ${yellow}paquetes${reset}"
cat <<EOT > ${PWD_F}/${TMP_F}/${MOUNT_R}/tmp/update.sh
#!/bin/bash
apt-get update -y
apt-get upgrade -y
EOT

chroot ${PWD_F}/${TMP_F}/${MOUNT_R} \
  /usr/bin/qemu-arm-static /bin/bash \
  /tmp/update.sh

rm ${PWD_F}/${TMP_F}/${MOUNT_R}/tmp/update.sh

cat <<EOT > ${PWD_F}/${TMP_F}/${MOUNT_R}/etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOT

echo "T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100" >> ${PWD_F}/${TMP_F}/${MOUNT_R}/etc/inittab

echo "${bold}Ejecutando ${yellow}custom.sh${reset}"
cp ${PWD_F}/include/colores.sh ${PWD_F}/${TMP_F}/${MOUNT_R}/colores.sh
cp ${PWD_F}/include/custom.sh ${PWD_F}/${TMP_F}/${MOUNT_R}/custom.sh
chroot ${PWD_F}/${TMP_F}/${MOUNT_R} \
  /usr/bin/qemu-arm-static /bin/bash \
  /custom.sh
rm ${PWD_F}/${TMP_F}/${MOUNT_R}/custom.sh
rm ${PWD_F}/${TMP_F}/${MOUNT_R}/colores.sh

echo "${bold}Desmontando carpetas ${yellow}proc dev sys${reset}"
sleep 1
umount ${PWD_F}/${TMP_F}/${MOUNT_R}/dev/pts
for i in proc dev sys; do 
  umount ${PWD_F}/${TMP_F}/${MOUNT_R}/$i
done
sleep 1
umount /dev/mapper/${parts[1]}

#Desmontando particiones loop
echo "${bold}Borrando loops ${yellow}${parts[@]}${reset}"
kpartx -d ${PWD_F}/${TMP_F}/${TMP_DEV}

