#!/bin/bash

### this script is for h5 auto upgrade
if [ -z "$2" ]; then
    echo "pls following the format to upgrade bridge mcu:"
    echo "./stm32flash $pwd/image/stm32*.bin"
  exit 1
fi

CURRENT_FOLDER=$PWD
GPIO_FOLDER=/sys/class/gpio
GPIO_BOOT0_FOLDER=/sys/class/gpio/gpio115
GPIO_RESET_FOLDER=/sys/class/gpio/gpio96

echo 96 > $GPIO_FOLDER/export
echo 115 > $GPIO_FOLDER/export

cd $GPIO_RESET_FOLDER
echo out > direction
cd $GPIO_BOOT0_FOLDER
echo out > direction
echo 1 > value

cd $GPIO_RESET_FOLDER
echo 0 > value
sleep 1
echo 1 > value
sleep 1

##### $1 this should be h5 flash.bin file with pwd path
$CURRENT_FOLDER/stm32flash -w  $1 -v -g 0x0 -b 115200 /dev/ttymxc3

sleep 1
cd $GPIO_BOOT0_FOLDER
echo 0 > value

cd $GPIO_RESET_FOLDER
echo 0 > value
sleep 1
echo 1 > value
sleep 1
echo 96 > $GPIO_FOLDER/unexport
echo 115 > $GPIO_FOLDER/unexport
sleep 3