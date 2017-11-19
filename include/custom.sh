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

source /colores.sh

PWD_F="$(pwd)"
TMP_F="tmp"
TMP_DEV="image.raw"
MOUNT_R="mnt"
OUTPUT_F="output"
KERNEL_F="linux-sunxi"
DISTRO="wheezy"
LOCALES="es_MX.UTF8 UTF-8"
NOMBRE_HOST="ciclope"

NEW_USER="meganucleo"
FECHA="$(date +%Y%m%d)"
#WALLPPR="meganucleo_wallpaper-3840x2160.jpg"
#REPLACEW="meganucleo_wallpaper.jpg"
#WALLPAPER_FOLDER="/usr/share/backgrounds/xfce"
#WALLPAPER_FOLDER_SED="\/usr\/share\/backgrounds\/xfce"
#WALLPAPER_CONFIG_FOLDER="/home/$NEW_USER/.config/xfce4/xfce-perchannel-xml/"
#WALLPAPER_CONFIG="xfce4-desktop.xml"

##Changing root password
echo "${NEGRITAS}Cambiando password de ${AMARILLO}root${RESET}"
echo root:meganucleo|chpasswd

##Borrando iconos de escritorio
echo "${NEGRITAS}Borrando iconos en ${AMARILLO}escritorio${RESET}"
rm -f /etc/skel/Desktop/*.desktop


##Installing postgresql and python tools
echo "${NEGRITAS}Actualizando e instalando ${AMARILLO}paquetes${RESET}"
apt-get install -y \
  locales 

##Generating locales
echo "Generando locales correctos" "${LOCALES}"
cat <<EOT > /etc/locale.gen
${LOCALES}
EOT
locale-gen

##Creando usuario meganucleo
echo "${NEGRITAS}Nuevo usuario ${AMARILLO}${NEW_USER}${RESET}"
[ "$( cat /etc/passwd | grep ${NEW_USER} -c )" != "1" ] && adduser --disabled-password --gecos "" $NEW_USER
if [ "$( cat /etc/passwd | grep ${NEW_USER} -c )" == "1" ] ; then
  echo "${NEGRITAS}Cambiando password a ${AMARILLO}${NEW_USER}${RESET}"
  echo $NEW_USER:mega1234|chpasswd
  echo "${NEGRITAS}Agregando a grupos ${AMARILLO}${NEW_USER}${RESET}"
  #for add_grp in sudo netdev audio video dialout plugdev bluetooth
  for add_grp in sudo dialout
  do
    usermod -aG ${add_grp} ${NEW_USER} 2>/dev/null
  done
fi


#touch /home/$NEW_USER/.Xauthority
#chown $NEW_USER:$NEW_USER /home/$NEW_USER/.Xauthority
#
###Enabling desktop environment
#if [ -f /etc/init.d/nodm ] ; then
#  sed -i "s/NODM_USER=\(.*\)/NODM_USER=${NEW_USER}/" /etc/default/nodm
#  sed -i "s/NODM_ENABLED=\(.*\)/NODM_ENABLED=true/g" /etc/default/nodm
#fi

##Changing hostname
echo "${NEGRITAS}Cambiando hostname ${AMARILLO}ciclope${FECHA}${RESET}"
echo "${NOMBRE_HOST}${FECHA}" > /etc/hostname
`sed -i '1s/^127\.0\.0\.1.*/127.0.0.1\tlocalhost\t${NOMBRE_HOST}${FECHA}/' /etc/hosts`

###Xorg configuration
#echo "Installing xorg config" 
#cp /tmp/overlay/xorg.config/10-evdev.conf /usr/share/X11/xorg.conf.d/
#cp /tmp/overlay/xorg.config/exynos.conf /usr/share/X11/xorg.conf.d/
#
###Xinput calibrator
#echo "Installing xinput_calibrator" 
#cp /tmp/overlay/xorg.config/xinput_calibrator /usr/bin
#cp /tmp/overlay/xorg.config/xinput_calibrator.1.gz /usr/share/man/man1/
#
###Install wallpaper
#echo "Installing wallpaper" 
#cp /tmp/overlay/meganucleo/$WALLPPR $WALLPAPER_FOLDER/$REPLACEW
#mkdir -p $WALLPAPER_CONFIG_FOLDER
#chown -R $NEW_USER $WALLPAPER_CONFIG_FOLDER
#cat /tmp/overlay/meganucleo/$WALLPAPER_CONFIG | sed -e "s/WREPLACEW/${WALLPAPER_FOLDER_SED}\/${REPLACEw}/" > $WALLPAPER_CONFIG_FOLDER/$WALLPAPER_CONFIG
#chown -R $NEW_USER $WALLPAPER_CONFIG_FOLDER/$wALLPAPER_CONFIG


##Cargar modulo ft5x_ts al inicio
echo "${NEGRITAS}Agregar a modules ${AMARILLO}ft5x_ts, mali, sunxi-emac${RESET}"
cat <<EOT > /etc/modules
ft5x_ts
mali
gpio_sunxi
sunxi-emac
EOT

##Quitar la informacion del sistema
echo "${NEGRITAS}Quitando informacion de sistema ${RESET}"
echo "Meganucleo CICLOPE" > /etc/issue
echo "Meganucleo CICLOPE" > /etc/issue.net
echo "${NEGRITAS}Cambiando motd ${RESET}"
#rm /etc/update-motd.d/*
echo "Bienvenido a meganucleo CICLOPE ${FECHA}" > /etc/motd
echo " " >> /etc/motd

#Cambiando el prompt
cat <<EOT >>/home/${NEW_USER}/.bashrc

VERDE='\[`tput setaf 2`\]'  #   2 Green
AMARILLO='\[`tput setaf 3`\]'  #  3 Yellow
CYAN='\[`tput setaf 6`\]'  #  6 Cyan
RESET='\[`tput sgr0`\]'
PS1="$CYAN\u$RESET@$VERDE\h$RESET|$AMARILLO\W$RESET\n> "
EOT

#Cambiando el archivo de evdev en xorg.d
cat <<EOT >/usr/share/X11/xorg.conf.d/10-evdev.conf
#
# Catch-all evdev loader for udev-based systems
# We don't simply match on any device since that also adds accelerometers
# and other devices that we don't really want to use. The list below
# matches everything but joysticks.

Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
       Identifier "evdev touchscreen catchall"
       MatchIsTouchscreen "on"
       MatchDevicePath "/dev/input/event*"
       Driver "evdev"
       MatchProduct "ft5x_ts"
       #Option "Calibration" "14 807 18 490"
       #Option "Calibration" "8 404 2 252"
       #Option "Calibration" "0 800 0 480"
       Option "Mode" "Absolute"
EndSection
EOT

#Agregando configuración de aceleración a Xorg
cat <<EOT >/usr/share/X11/xorg.conf.d/exynos.conf
Section "Device"
        Identifier      "Mali FBDEV"
        Driver          "fbdev"
        Option          "fbdev"                 "/dev/fb0"
        Option          "Fimg2DExa"             "false"
        Option          "DRI2"                  "true"
        Option          "DRI2_PAGE_FLIP"        "false"
        Option          "DRI2_WAIT_VSYNC"       "true"
#       Option          "Fimg2DExaSolid"        "false"
#       Option          "Fimg2DExaCopy"         "false"
#       Option          "Fimg2DExaComposite"    "false"
        Option          "SWcursorLCD"           "false"
EndSection
 
Section "Screen"
        Identifier      "DefaultScreen"
        Device          "Mali FBDEV"
        DefaultDepth    24
EndSection
EOT

#Autoarrancando usuario en entorno gráfico
echo "${NEGRITAS}Auto-arrancand usuario ${AMARILLO}${NEW_USER}${RESET}"
cat <<EOT > /etc/lightdm/lightdm.conf
[SeatDefaults]
autologin-user=meganucleo
autologin-user-timeout=0
greeter-session=lightdm-greeter
user-session=lxsession
xserver-allow-tcp=false
session-wrapper=/etc/X11/Xsession
EOT

#Evitando el screensaver
echo "${NEGRITAS}Evitando el ${AMARILLO}ScreenSaver${RESET}"
cat <<EOT > /etc/xdg/lxsession/LXDE/autostart
@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
@xset s off
@xset -dpms
@xset s noblank
EOT

###Evitar que arranquen servicios
#echo "Removing services from starting"
#systemctl disable tftpd-hpa
##proftpd.service
#systemctl disable proftpd
##nfs-kernel-server.service
##nfs-common.service
#systemctl disable nfs-kernel-server
#systemctl disable nfs-common
##snmpd.service  
#systemctl disable snmpd
##samba.service
#systemctl disable nmbd
#systemctl disable samba-ad-dc
#systemctl disable smbd

###Removing first boot
#echo "Removing first boot"
#rm /root/.not_logged_in_yet
#
###Installing firewall
#echo "Installing iptables"
#cp /tmp/overlay/meganucleo/firewall/iptables.up.rules /etc/iptables.up.rules
#cp /tmp/overlay/meganucleo/firewall/if-pre-up.d-iptables /etc/network/if-pre-up.d/iptables
#chmod +x /etc/network/if-pre-up.d/iptables

###Sobreescribiendo la config de sshd
#echo "${NEGRITAS}Modificando configuracion ${AMARILLO}sshd${RESET}"
#cp /sshd_config /etc/ssh/sshd_config

###Overwritting sudoers file
#echo "Overwritting sudoers file"
#cp /tmp/overlay/meganucleo/sudoers/sudoers /etc/sudoers


###Writting xsession in meganucleo user
#echo "Writting xsession file in $NEW_USER"
#cp /tmp/overlay/xorg.config/xsession /home/$NEW_USER/.xsession
#chown $NEW_USER:$NEW_USER /home/$NEW_USER/.xsession
#
###Disabling screensaver
#echo "Disabling screensaver"
#cp /tmp/overlay/meganucleo/disableDPMS.sh /home/$NEW_USER/disableDPMS.sh
#
###Installing Ciclope-scanner.desktop
#echo "Installing Ciclope-scanner launcher in $NEW_USER"
#cp /tmp/overlay/xorg.config/Ciclope-scanner.desktop /home/$NEW_USER/Desktop
#chown $NEW_USER:$NEW_USER /home/$NEW_USER/Desktop/Ciclope-scanner.desktop
#chmod 755 /home/$NEW_USER/Desktop/Ciclope-scanner.desktop


###Installing Ciclope-pyside
#echo "Installing Ciclope-pyside"
##tar -C /home/$NEW_USER -xjvf /tmp/overlay/meganucleo/ciclope/ciclope-pyside-1.0.tar.bz2
#tar -C /home/$NEW_USER -xjvf /tmp/overlay/meganucleo/ciclope/ciclope-pyside-1.0.1.tar.bz2
#chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/ciclope-pyside


##Installing fail2ban
#apt-get install fail2ban -y
#tar -zxf /tmp/overlay/meganucleo/fail2ban/fail2ban_port2222.tar.gz -C /

##Disable rsyslog I2C error
#cp /tmp/overlay/system/rsyslog.d/01-blocklist.conf /etc/rsyslog.d/01-blocklist.conf

##Installing postgresql and python tools
echo "${NEGRITAS}Actualizando e instalando ${AMARILLO}paquetes${RESET}"
apt-get install -y \
  network-manager network-manager-openvpn \
  python-psycopg2 python-pyside
  #postgresql-9.1 postgresql-client-9.1 \
  #postgresql-client-common postgresql-common \
  #sudo vim task-lxde-desktop
  #postgresql postgresql-9.4 postgresql-client-9.4 \
  #postgresql-client-common postgresql-common \
  #postgresql-contrib-9.4 

