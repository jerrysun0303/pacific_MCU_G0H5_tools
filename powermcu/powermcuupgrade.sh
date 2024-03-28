#!/bin/bash

### this script is for powermcu auto upgrade
echo "Before Upgrade Power MCU Version: "
ocean-hwclock --version

if [ -z "$1" ]; then
    echo "Pls following the format to upgrade power mcu:"
    echo "   ./powermcuupgrade.sh $pwd/image/stm32*.bin"
  exit 1
fi

CURRENT_FOLDER=$PWD
GPIO_FOLDER=/sys/class/gpio
GPIO_BOOT0_FOLDER=/sys/class/gpio/gpio1
GPIO_RESET_FOLDER=/sys/class/gpio/gpio0

echo 0 > $GPIO_FOLDER/export
echo 1 > $GPIO_FOLDER/export

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

##### $1 this should be powermcu flash.bin file with pwd path
$CURRENT_FOLDER/stm32flash -w  $1 -v -g 0x0 -b 115200 /dev/ttymxc0

sleep 1
cd $GPIO_BOOT0_FOLDER
echo 0 > value

cd $GPIO_RESET_FOLDER
echo 0 > value
sleep 1
echo 1 > value
sleep 1

echo 0 > $GPIO_FOLDER/unexport
echo 1 > $GPIO_FOLDER/unexport

###must wait for powermcu wake up
sleep 5
cd $CURRENT_FOLDER
echo "After Upgrade Power MCU Version: "
ocean-hwclock --version