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

bold=`tput bold`
black=`tput setaf 0` #   0  Black
red=`tput setaf 1`  #   1 Red
green=`tput setaf 2`  #   2 Green
yellow=`tput setaf 3`  #  3 Yellow
blue=`tput setaf 4`  #  4 Blue
magenta=`tput setaf 5`  #   5 Magenta
cyan=`tput setaf 6`  #  6 Cyan
white=`tput setaf 7`  #   7 White
reset=`tput sgr0`