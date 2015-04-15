#!/bin/bash

# Установка свежего среза портеджей
emerge-webrsync

# Настройка профиля
eselect profile set default/linux/amd64/13.0

# Настройка часового пояса
echo "Europe/Moscow" > /etc/timezone

# Применение настроек временной зоны
emerge --config sys-libs/timezone-data

# Настройка параметров локализации
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen

# Генерация профилей локализации
locale-gen

# Выбор профиля локализации
eselect locale set ru_RU.UTF-8

# Обновление переменных окружения
env-update && source /etc/profile

# Установка исходных кодов ядра
emerge -q sys-kernel/gentoo-sources

# Настройка ядра
cd /usr/src/linux
wget http://piblic.t-brain.ru/conf/kernel-server -O /usr/src/linux/.config

# Сборка нового ядра
make && make modules_install

# Установка нового ядра
make install
mkdir -p /boot/efi/boot
cp /boot/vmlinuz* /boot/efi/boot/bootx64.efi

# Настройка файловых систем
echo $DISK1[1]   /boot        ext4    defaults,noatime     0 2 > /etc/fstab
echo $DISK1[1]   none         swap    sw                   0 0 >> /etc/fstab
echo $DISK1[1]   /            ext4    noatime              0 1 >> /etc/fstab
echo  >> /etc/fstab
echo $DISK1[1]   /dev/cdrom  /mnt/cdrom   auto    noauto,user          0 0 >> /etc/fstab

# Настройка параметров имени комптютера
echo "hostname=\"$HOST\""

# Настройка параметров сети
echo "dns_domain_lo=\"$DOMAIN\"" > /etc/conf.d/net
echo "config_$Lan1=\"$IP1 netmask $MASK1\"" >> /etc/conf.d/net
echo "routes_$Lan1=\"default via $GW\"" >> /etc/conf.d/net

# /etc/hosts
echo "127.0.0.1       $HOST.$DOMAIN $HOST" > /etc/hosts
echo "127.0.0.1       $HOST.$DOMAIN." >> /etc/hosts
echo "127.0.0.1       localhost" >> /etc/hosts

# Добавление в автозапуск сетевого адартора
cd /etc/init.d
ln -s net.lo net.$Lan1
rc-update add net.$Lan1 default

# Назначение пароля суперпользователю
usermod -p '$6$h9mmuWBb$uOoOa81m4BXXaMUX5N069SoXblyD9/38Xf2v1BTdIE.kaA2AWhCpZyT9tdnaZsqTFIzT79kTv6iCdYO6yMjzF.' root

# Компонент для ведения системных логов
emerge -q app-admin/syslog-ng
rc-update add syslog-ng default

# Планировщик заданий
emerge -q sys-process/cronie
rc-update add cronie default
crontab /etc/crontab

#Индексация файлов
emerge -q sys-apps/mlocate

#Удаленный доступ
rc-update add sshd default






