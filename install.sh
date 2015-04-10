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

