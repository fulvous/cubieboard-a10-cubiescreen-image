function uso {
  jumbotron \
  "${BLANCO}$0${AMARILLO} soporta estas opciones:" \
  "  -g          Hacer imagen grafica." \
  "  -i          NO crear imagen SD." \
  "  -k          NO compiles kernel." \
  "  -m          Ejecuta kernel menu." \
  "  -p          NO ejecutes ${CYAN}include/patch.sh${RESET}." \
  "  -u          NO compiles u-boot." \
  "  -r          Borra todos los directorios." \
  "  -s 8        Cambia tamaño de imagen (GB)" \
  "  -v          Muestra informacion adicional." \
  "  -h          Imprime esta ayuda." 
}

