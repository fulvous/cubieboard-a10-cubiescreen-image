function uso {
  jumbotron \
  "${BLANCO}$0${AMARILLO} soporta estas opciones:" \
  "  -g                       Hacer imagen grafica." \
  "  -d wheezy|xenial         Nombre de la distribución." \
  "  -i                       NO crear imagen SD." \
  "  -k                       NO compiles kernel." \
  "  -m                       Ejecuta kernel menu." \
  "  -p                       Crea parches en Kernel." \
  "  -u                       NO compiles u-boot." \
  "  -r                       Borra todos los directorios." \
  "  -s TAMANO_GB             Cambia tamaño de imagen (GB)" \
  "  -v                       Muestra informacion adicional." \
  "  -h                       Imprime esta ayuda." 
}

