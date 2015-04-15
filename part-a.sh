#!/bin/bash
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
cd /mnt/gentoo
wget http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/`links -source http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/latest-stage3-amd64.txt | grep stage3 | awk '{print $1}'`
tar xvjpf stage3-*.tar.bz2


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
wget http://
chroot /mnt/gentoo/ /bin/bash -c /tmp/part-b.sh


# Отмонтирование и перезагрузка
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount /mnt/gentoo{/boot,/sys,/proc,}
reboot
