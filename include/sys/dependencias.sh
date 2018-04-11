function dependencias {
  #Instalando paquetes necesarios
  informa "Instalando" "Paquetes" "necesarios"
  apt-get install -y \
    qemu binfmt-support qemu-user-static \
    gcc-arm-linux-gnueabihf pigz debootstrap \
    kpartx make gcc libusb-1.0-0-dev \
    pkg-config libz-dev u-boot-tools \
    libncurses-dev
  
  res_ok "Paquetes" "instalados" "Exitoso"
}
