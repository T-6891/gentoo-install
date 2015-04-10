#!/bin/bash

# Импорт сетевых настроек
DIALOG=${DIALOG=dialog}
tempfile2=`tempfile2 2>/dev/null` || tempfile2=/tmp/snet$$
tempfile3=`tempfile3 2>/dev/null` || tempfile3=/tmp/mnet$$
trap "rm -f $tempfile2 $tempfile3" 0 1 2 5 15

dialog --backtitle "Network Settings" --title "Network Settings" \
--no-shadow --menu "Please import the active network settings or enter manually." 0 0 0 "import" "import the active network settings?" \
"manual" "Manual Ip Setting" 2> $tempfile2

retval=$?
choice=`cat $tempfile2`
case $choice in
        "import")  
        IFACE=`ifconfig | grep RUNNING | awk '{print $1}' | sed -r 's/[:^]+//' | grep -v lo`
        IP=`ifconfig $IFACE | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk -v RS=' ' '!(NR%1){gsub(/\n/," ");print} ' | grep -A 1 inet | grep -v inet`
        MASK=`ifconfig $IFACE  | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk -v RS=' ' '!(NR%1){gsub(/\n/," ");print} ' | grep -A 1 netmask | grep -v netmask`
        GW=`netstat -rn | awk '{print $1, $2}' | grep "0.0.0.0 " | awk '{print $2}'`
        ;;
        "manual")
        dialog --backtitle "Dialog Test Example" --title "IP Settings" \
        --no-shadow --inputbox "EnterIP:" 0 0 "192.168.1.100" 2> $tempfile3
        IPPI=`cat  $tempfile3`
        ;;
esac


# Выбор диска для установки
DT=/tmp/DISKS$$

fdisk -l | grep "Disk " | grep -v identifier | grep -v loop0 | awk '{print $2, $3 $4}' | sed -r 's/(.*),$/\1/' | awk '{print $0" off "}' > $DT 

NDISK1=`awk 'NR == 1' $DT | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE1=`awk 'NR == 1' $DT | awk '{print $2, $3}'`
NDISK2=`awk 'NR == 2' $DT | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE2=`awk 'NR == 2' $DT | awk '{print $2, $3}'`
NDISK3=`awk 'NR == 3' $DT | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE3=`awk 'NR == 3' $DT | awk '{print $2, $3}'`
NDISK4=`awk 'NR == 4' $DT | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE4=`awk 'NR == 4' $DT | awk '{print $2, $3}'`
NDISK5=`awk 'NR == 5' $DT | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE5=`awk 'NR == 5' $DT | awk '{print $2, $3}'`
NDISK6=`awk 'NR == 6' $DT | awk '{print $1}' | sed -r 's/(.*):$/\1/'`
DSIZE6=`awk 'NR == 6' $DT | awk '{print $2, $3}'`

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/sdisk$$
trap "rm -f $tempfile $DT" 0 1 2 5 15

$DIALOG --backtitle "Preparing the disks" \
        --title "Selecting disks" --clear \
        --radiolist "Please specify the drive on which the system will be installed" 16 50 6 \
        \
        $NDISK1 $DSIZE1 \
        $NDISK2 $DSIZE2 \
        $NDISK3 $DSIZE3 \
        $NDISK4 $DSIZE4 \
        $NDISK5 $DSIZE5 \
        $NDISK6 $DSIZE6  2> $tempfile

retval=$?

DISK=`cat $tempfile`
case $retval in
  1)
    echo "Cancel pressed.";;
  255)
    echo "ESC pressed.";;
esac

# Выбор схемы разбивки дисков
