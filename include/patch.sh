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

informa "Parchando" "kernel" "Drivers multimedia"

#cp -v /home/lramos/.config ${PWD_F}/${KERNEL_F}/.config
##
##tar xvf ${PWD_F}/sources/cubiescreen/cubiescreen_drv.tar \
##  -C ${PWD_F}/${TMP_F}
##
##cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/touchscreen/* \
##  ${PWD_F}/${KERNEL_F}/drivers/input/touchscreen/
##cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/video/disp/* \
##  ${PWD_F}/${KERNEL_F}/drivers/video/sunxi/disp/
##cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/video/lcd/* \
##  ${PWD_F}/${KERNEL_F}/drivers/video/sunxi/lcd/
##cp -v ${PWD_F}/${TMP_F}/cubiescreen/driver/ctp.h \
##  ${PWD_F}/${KERNEL_F}/include/linux/
##
##patch ${PWD_F}/${KERNEL_F}/.config  \
##  ${PWD_F}/sources/kernel/config.patch
##patch ${PWD_F}/${KERNEL_F}/drivers/i2c/busses/i2c-sunxi.c \
##  ${PWD_F}/sources/kernel/i2c-sunxi.c.patch
##
####Parchando driver ft5x_ts
###patch ${PWD_F}/${KERNEL_F}/drivers/input/touchscreen/ft5x_ts.c  \
###  ${PWD_F}/sources/kernel/ft5x_ts.c.patch
###
####Parchando driver auo_pixcir_ts
###patch ${PWD_F}/${KERNEL_F}/drivers/input/touchscreen/auo-pixcir-ts.c  \
###  ${PWD_F}/sources/kernel/auo-pixcir-ts.c.patch
##
res_ok "Parches y drivers para" "ubuntu" "Exitoso"
