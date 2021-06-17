#!/bin/sh
opt=`find . -name "$1"`

for f in $opt
do
 echo $f
done
if test "x${opt}" != "x" ; then
   read -p "Copy these files to folder?" path
   if test "x$path" != "x"; then
      eval path=$path
      mkdir -p $path
      for f in $opt
      do
         cp -raf $f $path
      done
   else
      echo "bye"
   fi
fi
exit 0
