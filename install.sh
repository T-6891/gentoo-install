#!/bin/bash

# Импорт сетевых настроек
dialog --title 'Network Settings' --yesno 'Do you want to import the active network settings?' 10 40

case "$?" in
        '0')
        IFACE=`ifconfig | grep RUNNING | awk '{print $1}' | sed -r 's/[:^]+//' | grep -v lo`
        IP=`ifconfig $IFACE | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk -v RS=' ' '!(NR%1){gsub(/\n/," ");print} ' | grep -A 1 inet | grep -v inet`
        MASK=`ifconfig $IFACE  | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk -v RS=' ' '!(NR%1){gsub(/\n/," ");print} ' | grep -A 1 netmask | grep -v netmask`
        GW=`netstat -rn | awk '{print $1, $2}' | grep "0.0.0.0 " | awk '{print $2}'`
        ;;
        '1')
        exit
        ;;
        '-1')
        echo 'You came by pressing ESC, or inside the installer error occurred'
        exit 1
        ;;
esac

# Выбор диска для установки
fdisk -l | grep "Disk " | grep -v identifier | grep -v loop0 | awk '{print $2, $3 $4}' | sed -r 's/(.*),$/\1/' | awk '{print $0" off "}' > /tmp/DISKS

NDISK1=`awk 'NR == 1' /tmp/DISKS | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE1=`awk 'NR == 1' /tmp/DISKS | awk '{print $2, $3}'`
NDISK2=`awk 'NR == 2' /tmp/DISKS | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE2=`awk 'NR == 2' /tmp/DISKS | awk '{print $2, $3}'`
NDISK3=`awk 'NR == 3' /tmp/DISKS | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE3=`awk 'NR == 3' /tmp/DISKS | awk '{print $2, $3}'`
NDISK4=`awk 'NR == 4' /tmp/DISKS | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE4=`awk 'NR == 4' /tmp/DISKS | awk '{print $2, $3}'`
NDISK5=`awk 'NR == 5' /tmp/DISKS | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE5=`awk 'NR == 5' /tmp/DISKS | awk '{print $2, $3}'`
NDISK6=`awk 'NR == 6' /tmp/DISKS | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE6=`awk 'NR == 6' /tmp/DISKS | awk '{print $2, $3}'`

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/sdisk$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "Preparing the disks" \
        --title "Selecting disks" --clear \
        --radiolist "Please specify the drive on which the system will be installed " 20 61 5 \
        $NDISK1 $DSIZE1 \
        $NDISK2 $DSIZE2 \
        $NDISK3 $DSIZE3 \
        $NDISK4 $DSIZE4 \
        $NDISK5 $DSIZE5 \
        $NDISK6 $DSIZE6  2> $tempfile

retval=$?

choice=`cat $tempfile`
case $retval in
  0)
    echo " ";;
  1)
    echo "Cancel pressed.";;
  255)
    echo "ESC pressed.";;
esac
