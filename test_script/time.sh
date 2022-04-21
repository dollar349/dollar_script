#!/bin/sh

time=$1
m=`expr $time / 60`
s=`expr $time % 60`

if [ $m -eq 0 ];then
  echo "Time taken $s seconds"
else
  echo "Time taken $m miunt $s seconds"
fi
