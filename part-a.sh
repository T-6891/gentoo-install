#!/bin/bash
# Network Settings
Lan1=`grep Lan1 /tmp/gentoo-install/install.conf | awk '{print $3}'`
IP1=`grep IP1 /tmp/gentoo-install/install.conf | awk '{print $3}'`
MASK1=`grep MASK1 /tmp/gentoo-install/install.conf | awk '{print $3}'`
GW=`grep GW /tmp/gentoo-install/install.conf | awk '{print $3}'`
HOST=`grep HOST /tmp/gentoo-install/install.conf | awk '{print $3}'`
DOMAIN=`grep DOMAIN /tmp/gentoo-install/install.conf | awk '{print $3}'`
DISK1=`grep DISK1 /tmp/gentoo-install/install.conf | awk '{print $3}'`
PARTDISK=`grep PARTDISK /tmp/gentoo-install/install.conf | awk '{print $3}'`


# Compilation Settings
MAKECONF="/mnt/gentoo/etc/portage/make.conf"

# Console dialog
red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)

clear
sleep 1
echo '###################################################################'
echo ''
echo ' ______ _______ __   _ _______  _____   _____'
echo '|  ____ |______ | \  |    |    |     | |     |'
echo '|_____| |______ |  \_|    |    |_____| |_____|'
echo ''
echo '           _____ __   _ _     _ _     _'
echo '    |        |   | \  | |     |  \___/'
echo '    |_____ __|__ |  \_| |_____| _/   \_'
echo ''
echo ''
echo '###################################################################'
sleep 5
echo ''
echo ''
# Разметка диска
for i in 'Создание разделов диска...'; do printf "$i\r"; done
if [ "$PARTDISK" == "FS" ]
then
        PARTDISKSCHEME="/tmp/gentoo-install/conf/fs.conf"
else
        PARTDISKSCHEME="/tmp/gentoo-install/conf/lvm.conf"
fi

while read line
do
parted -sa optimal $DISK1 "$line"   
done < $PARTDISKSCHEME
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
    echo 'Произошла критическая ошибка! Продолжение установки невозможно...'
fi
echo -n "${reset}"
echo

# Форматирование разделов
for i in 'Форматирование разделов...'; do printf "$i\r"; done
mkfs.ext4 $DISK1[2]  
mkfs.ext4 $DISK1[4]  
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Активация раздела подкачки
for i in 'Активация раздела подкачки...'; do printf "$i\r"; done
mkswap $DISK1[3] 
swapon $DISK1[3] 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Монтирование
for i in 'Монтирование разделов...'; do printf "$i\r"; done
mount /dev/sda4 /mnt/gentoo 
mkdir /mnt/gentoo/boot 
mount /dev/sda2 /mnt/gentoo/boot 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Синхронизация времени
for i in 'Синхронизация времени...'; do printf "$i\r"; done
/usr/sbin/ntpdate -u pool.ntp.org 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Загрузка свежего среза системы
for i in 'Загрузка актуального среза системы...'; do printf "$i\r"; done
cd /mnt/gentoo  
wget http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/`links -source http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/latest-stage3-amd64.txt | grep stage3 | awk '{print $1}'`  
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Распаковка архива...'; do printf "$i\r"; done
tar xvjpf stage3-*.tar.bz2  
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Настройка опции компиляции
for i in 'Настройка опции компиляции...'; do printf "$i\r"; done
echo 'CFLAGS="-march=native -O2 -pipe"' > $MAKECONF
echo 'CXXFLAGS="${CFLAGS}"' >> $MAKECONF
echo 'CHOST="x86_64-pc-linux-gnu"' >> $MAKECONF
echo " " >> $MAKECONF
echo 'USE="-ipv6 -X -cups -alsa bindist mmx sse sse2 acl threads sockets symlink vim-syntax unicode"' >> $MAKECONF
echo " " >> $MAKECONF
echo 'PORTDIR="/usr/portage"' >> $MAKECONF
echo 'DISTDIR="${PORTDIR}/distfiles"' >> $MAKECONF
echo 'PKGDIR="${PORTDIR}/packages"' >> $MAKECONF
echo " " >> $MAKECONF
echo MAKEOPTS=\"-j$((`cat /proc/cpuinfo | grep processor | wc -l` + 1))\" >> $MAKECONF
echo " " >> $MAKECONF
echo 'GENTOO_MIRRORS="http://mirror.yandex.ru/gentoo-distfiles/"' >> $MAKECONF
echo " " >> $MAKECONF
mkdir -p /etc/portage/repos.conf/ 
echo '[gentoo]' > /etc/portage/repos.conf/gentoo.conf
echo 'location = /usr/portage' >> /etc/portage/repos.conf/gentoo.conf
echo 'sync-type = rsync' >> /etc/portage/repos.conf/gentoo.conf
echo 'sync-uri = rsync://mirror.yandex.ru/gentoo-portage' >> /etc/portage/repos.conf/gentoo.conf
echo 'auto-sync = yes' >> /etc/portage/repos.conf/gentoo.conf
echo ' ' >> /etc/portage/repos.conf/gentoo.conf
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Копирование DNS настроек
for i in 'Копирование настроек DNS...'; do printf "$i\r"; done
cp -L /etc/resolv.conf /mnt/gentoo/etc/ 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Копирование конфигурационных файлов
for i in 'Копирование конфигурационных файлов...'; do printf "$i\r"; done
cp /tmp/gentoo-install/conf/install.conf /mnt/gentoo/tmp/install.conf 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Монтирование необходимых файловых систем
for i in 'Монтирование необходимых файловых систем...'; do printf "$i\r"; done
mount -t proc proc /mnt/gentoo/proc 
mount --rbind /sys /mnt/gentoo/sys 
mount --make-rslave /mnt/gentoo/sys 
mount --rbind /dev /mnt/gentoo/dev 
mount --make-rslave /mnt/gentoo/dev 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Переход в новое окружение (chroot)
for i in 'Переход в новое окружение (chroot)...'; do printf "$i\r"; done
cp /tmp/gentoo-install/part-b.sh /mnt/gentoo/tmp/ 
cp /tmp/gentoo-install/conf/kernel /mnt/gentoo/src/linux/.config
cd /mnt/gentoo/tmp/ 
chmod +x ./part-b.sh 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

chroot /mnt/gentoo/ /bin/bash -c /tmp/part-b.sh


# Перезагрузка
for i in 'Перезагрузка системы...'; do printf "$i\r"; done
cd 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo
echo '###################################################################'
echo " "
echo 'Установка завершена!' 
echo " "
sleep 1
echo "Система будет перезагружена" 
echo " "
sleep 1
read -p "Для продолжения нажмите [${red}enter${reset}] ..."
reboot

