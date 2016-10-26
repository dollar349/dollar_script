#/bin/sh
GCC_PATH=`pwd`/"tmp/sysroots/x86_64-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gcc"
SYS_ROOT=`pwd`/tmp/sysroots/tm-am335x-cpm3
ICCOM_GCC="${GCC_PATH} -march=armv7-a -marm  -mthumb-interwork -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 --sysroot=${SYS_ROOT}"

#echo ${ICCOM_GCC} $*
${ICCOM_GCC} $*


