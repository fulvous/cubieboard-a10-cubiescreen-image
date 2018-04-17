function firstboot {
  ##Colocando script de arranque
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/etc/rc.local
##Coloca cualquier comando antes del exit 0
[ -f /usr/local/bin/inicial.sh ] && /usr/local/bin/inicial.sh
exit 0
EOT

  [ ! -d ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin ] && mkdir -p ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin
  touch ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin/primera
 
cat <<EOT > ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin/inicial.sh
#!/bin/bash

if [ -f /usr/local/bin/primera ] ; then
        echo ",+" | sfdisk -N 2 /dev/mmcblk0 --force --no-reread
        rm /usr/local/bin/primera
        touch /usr/local/bin/segunda
        reboot
else 
        if [ -f /usr/local/bin/segunda ] ; then 
                rm /usr/local/bin/segunda
                resize2fs /dev/mmcblk0p2
        fi
fi

## rm /usr/local/bin/inicial.sh
EOT

  ##Dar permiso de ejecución a primer arranque
  chmod 755 ${PWD_F}/${TMP_F}/${MNT}/usr/local/bin/inicial.sh
}
