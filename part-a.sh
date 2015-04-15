#!/bin/bash
# Network Settings
Lan1=`grep Lan1 ./install.conf | awk '{print $3}'`
IP1=`grep IP1 ./install.conf | awk '{print $3}'`
MASK1=`grep MASK1 ./install.conf | awk '{print $3}'`
GW=`grep GW ./install.conf | awk '{print $3}'`
HOST=`grep HOST ./install.conf | awk '{print $3}'`
DOMAIN=`grep DOMAIN ./install.conf | awk '{print $3}'`
DISK1=`grep DISK1 ./install.conf | awk '{print $3}'`
PARTDISK=`grep PARTDISK ./install.conf | awk '{print $3}'`


# Compilation Settings
MAKECONF="/mnt/gentoo/etc/portage/make.conf"

# Console dialog
red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)

# Разметка диска
if [ "$PARTDISK" == "FS" ]
then
        PARTDISKSCHEME="/tmp/fs.conf"
else
        PARTDISKSCHEME="/tmp/lvm.conf"
fi

while read line
do
parted -sa optimal $DISK1 "$line"
done < $PARTDISKSCHEME


# Форматирование разделов
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4


# Активация раздела подкачки
mkswap /dev/sda3
swapon /dev/sda3


# Монтирование
mount /dev/sda4 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/sda2 /mnt/gentoo/boot


# Синхронизация времени
/usr/sbin/ntpdate -u pool.ntp.org 


# Загрузка свежего среза системы
for i in 'Downloading the stage tarball'; do printf "$i\r"; done
cd /mnt/gentoo  > /dev/null 2>&1
wget http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/`links -source http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/latest-stage3-amd64.txt | grep stage3 | awk '{print $1}'`  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Unpacking the stage tarball'; do printf "$i\r"; done
tar xvjpf stage3-*.tar.bz2  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Настройка опции компиляции
echo 'CFLAGS="-march=native -O2 -pipe"' > $MAKECONF
echo 'CXXFLAGS="${CFLAGS}"' >> $MAKECONF
echo 'CHOST="x86_64-pc-linux-gnu"' >> $MAKECONF
echo " " >> $MAKECONF
echo 'USE="-ipv6 bindist mmx sse sse2 vim-syntax symlink"' >> $MAKECONF
echo " " >> $MAKECONF
echo 'PORTDIR="/usr/portage"' >> $MAKECONF
echo 'DISTDIR="${PORTDIR}/distfiles"' >> $MAKECONF
echo 'PKGDIR="${PORTDIR}/packages"' >> $MAKECONF
echo " " $MAKECONF
echo MAKEOPTS=\"-j$((`cat /proc/cpuinfo | grep processor | wc -l` + 1))\" >> $MAKECONF
echo " " >> $MAKECONF
echo 'GENTOO_MIRRORS="http://mirror.yandex.ru/gentoo-distfiles/"' >> $MAKECONF
echo 'SYNC="rsync://rsync2.ru.gentoo.org/gentoo-portage"' >> $MAKECONF
echo " " >> $MAKECONF


# Копирование DNS настроек
cp -L /etc/resolv.conf /mnt/gentoo/etc/


# Монтирование необходимых файловых систем
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev


# Переход в новое окружение (chroot)
cd /mnt/gentoo/
wget http://public.t-brain.ru/script/part-2.sh
chmod +x ./part-2.sh
chroot /mnt/gentoo/ /bin/bash -c /tmp/part-2.sh


# Отмонтирование и перезагрузка
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount /mnt/gentoo{/boot,/sys,/proc,}
reboot
