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

informa "Ejecutando" "custom-fuera" "fuera de la Jaula"

#debug "Copiando el xinput_calibrator"
#cp -v ${PWD_F}/${TMP_F}/cubiescreen/sdk_configure/xinput_calibrator \
#  ${PWD_F}/${TMP_F}/${MNT}/usr/bin
#
#cp -v ${PWD_F}/${TMP_F}/cubiescreen/sdk_configure/xinput_calibrator.1.gz \
#  ${PWD_F}/${TMP_F}/${MNT}/usr/share/man/man1

#debug "Copiando el árbol del kernel fuente para compilar futuros drivers"
#
##cp -r -v ${PWD_F}/${KERNEL_F} \
##  ${PWD_F}/${TMP_F}/${MNT}/usr/src/linux
#
#git clone -b sunxi-${KERNEL_V} https://github.com/linux-sunxi/linux-sunxi.git ${PWD_F}/${TMP_F}/${MNT}/usr/src/linux

res_ok "Custom fuera" "Ejecutado" "Exitoso"
