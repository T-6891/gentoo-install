#!/bin/bash

CONFIG="/tmp/gentoo-install/install.conf"

DIALOG=${DIALOG=dialog}
DT=/tmp/gentoo-install/DISKS
temp2=`temp2 2>/dev/null` || temp2=/tmp/gentoo-install/inet
tempfile3=`tempfile3 2>/dev/null` || tempfile3=/tmp/gentoo-install/ipnet
tempfile4=`tempfile4 2>/dev/null` || tempfile4=/tmp/gentoo-install/manet
tempfile5=`tempfile5 2>/dev/null` || tempfile5=/tmp/gentoo-install/gwnet
tempfile6=`tempfile6 2>/dev/null` || tempfile6=/tmp/gentoo-install/honet
tempfile7=`tempfile7 2>/dev/null` || tempfile7=/tmp/gentoo-install/donet
part=`part 2>/dev/null` || part=/tmp/gentoo-install/part
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/gentoo-install/sdisk$$

dialog --backtitle "Network setting" --title "Network setting" \
--no-shadow --menu "Import current network settings or enter them manually?" 0 0 0 "import" "Import the current network settings?" \
"manual" "Enter manually" 2> $temp2

retval=$?
choice=`cat $temp2`
case $choice in
        "import")  
        IFACE=`ifconfig | grep RUNNING | awk '{print $1}' | sed -r 's/[:^]+//' | grep -v lo | awk 'NR == 1'`
        IP=`ifconfig $IFACE | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk -v RS=' ' '!(NR%1){gsub(/\n/," ");print} ' | grep -A 1 inet | grep -v inet`
        MASK=`ifconfig $IFACE  | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk -v RS=' ' '!(NR%1){gsub(/\n/," ");print} ' | grep -A 1 netmask | grep -v netmask`
        GW=`netstat -rn | awk '{print $1, $2}' | grep "0.0.0.0 " | awk '{print $2}' | head -n1`
        dialog --backtitle "Network setting" --title "computer Name" \
        --no-shadow --inputbox "Enter hostname:" 0 0 "YourServer" 2> $tempfile6
        HOST=`cat  $tempfile6`
        dialog --backtitle "Network setting" --title "Domain" \
        --no-shadow --inputbox "Enter Domain:" 0 0 "company.ltd" 2> $tempfile7
        DOMAIN=`cat  $tempfile7`
        ;;
        "manual")
        IFACE=`ifconfig | grep RUNNING | awk '{print $1}' | sed -r 's/[:^]+//' | grep -v lo`
        dialog --backtitle "Network setting" --title "IP address" \
        --no-shadow --inputbox "Enter IP:" 0 0 "172.16.50.218" 2> $tempfile3
        IP=`cat  $tempfile3`
        dialog --backtitle "Network setting" --title "Network MASK" \
        --no-shadow --inputbox "Enter network mask:" 0 0 "255.255.255.0" 2> $tempfile4
        MASK=`cat  $tempfile4`
        dialog --backtitle "Network setting" --title "Gateway" \
        --no-shadow --inputbox "Enter Gateway:" 0 0 "172.16.50.1" 2> $tempfile5
        GW=`cat  $tempfile5`
        dialog --backtitle "Network setting" --title "computer Name" \
        --no-shadow --inputbox "Enter hostname:" 0 0 "YourServer" 2> $tempfile6
        HOST=`cat  $tempfile6`
        dialog --backtitle "Network setting" --title "Domain" \
        --no-shadow --inputbox "Enter Domain:" 0 0 "company.ltd" 2> $tempfile7
        DOMAIN=`cat  $tempfile7`
        ;;
esac

fdisk -l | grep "Disk /dev/" | grep -v "Disk /dev/ram" | grep -v loop | awk '{print $2, $3 $4}' | sed -r 's/(.*),$/\1/' | awk '{print $0" off "}' > $DT

# old
#fdisk -l | grep "Disk " | grep -v identifier | grep -v loop0 | awk '{print $2, $3 $4}' | sed -r 's/(.*),$/\1/' | awk '{print $0" off "}' | grep '/dev/sd*' > $DT

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

DISK1=`cat $tempfile`
retval=$?

case $retval in
  1)
    echo "Cancel pressed.";;
  255)
    echo "ESC pressed.";;
esac

$DIALOG --backtitle "Preparing the disks" \
        --title "Selecting disks" --clear \
        --radiolist "Please specify the drive on which the system will be installed" 16 50 6 \
        \
        FS "Partitioning the entire disc" ON \
        LVM "Partitioning for LVM" off 2> $part

retval=$?

PARTDISK=`cat $part`
case $retval in
  1)
    echo "Cancel pressed.";;
  255)
    echo "ESC pressed.";;
esac


trap "rm -f $temp2 $tempfile3 $tempfile4 $tempfile5 $tempfile6 $tempfile7 $tempfile $part $DT" 0 1 2 5 15

# ================================================================================================================================================================================

echo "Lan1     = $IFACE"        >  $CONFIG 
echo "IP1      = $IP"           >> $CONFIG
echo "MASK1    = $MASK"         >> $CONFIG
echo "GW       = $GW"           >> $CONFIG
echo " "
echo "HOST     = $HOST"         >> $CONFIG
echo "DOMAIN   = $DOMAIN"       >> $CONFIG
echo " "
echo "DISK1    = $DISK1"        >> $CONFIG
echo "PARTDISK = $PARTDISK"     >> $CONFIG
echo " "                        >> $CONFIG



cat $CONFIG

echo " "
echo " "
echo -n "Are you ready to start the installation? (y/n) "

read item
case "$item" in
    y|Y) echo "Enter «y» to continue..."
        ;;
    n|N) echo "Enter «n», to continue......"
        exit 0
        ;;
    *) echo "They didn’t enter anything. Perform the default action ..."
        ;;
esac

cd /tmp/gentoo-install
chmod +x ./part-a.sh > /dev/null 2>&1
time ./part-a.sh
#
