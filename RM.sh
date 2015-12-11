#!/bin/sh
echo "Will delete $* in backrund"
echo "Continue (y/n)? "
read -p "y:commit, n: cancel : " ans

if [ "$ans" == "y" ]; then
	for file in $*;
	do 
	 mv $file .$file
	 sudo -b nice --adjustment=19 rm -rf .$file	 
	done
else
        echo "  CANCELED"
fi
