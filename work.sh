#!/bin/sh
dollar()
{
	USER=dollar
	USERIP="10.162.243.194"
    if [ $1 == "mo" ]; then
		mkdir -p mo_${USER}
		sudo mount -t nfs ${USERIP}:/home/${USER} mo_${USER}

    fi

    if [ $1 == "umo" ]; then
       	sudo umount mo_${USER}
		rm -rf mo_${USER}
    fi	
}

edward()
{
	USER=edward
	USERIP="10.162.243.195"
    if [ $1 == "mo" ]; then
		mkdir -p mo_${USER}
		sudo mount -t nfs ${USERIP}:/home/${USER} mo_${USER}

    fi

    if [ $1 == "umo" ]; then
       	sudo umount mo_${USER}
		rm -rf mo_${USER}
    fi	
}


case "$1" in
  mo|mount)
  dollar mo
    ;;
  umo|umount)
  dollar umo
    ;;
  *)
    echo $"Usage: $0 {mo | umo}"
    RETVAL=1

esac
exit $RETVAL