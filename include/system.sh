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

cat <<EOT >> etc/fstab
none  /tmp  tmpfs defaults,noatime,mode=1777 0 0
/dev/sda1 /boot vfat  defaults  0 0
EOT

cat <<EOF > etc/resolv.conf
nameserver 8.8.8.8
nameserver 4.2.2.2
EOF

apt-get update -y

cat <<END > etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests "0";
END

echo "T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100" >> etc/inittab
