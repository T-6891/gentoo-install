#!/bin/bash
# Network Settings
Lan1=`grep Lan1 /tmp/install.conf | awk '{print $3}'`
IP1=`grep IP1 /tmp/install.conf | awk '{print $3}'`
MASK1=`grep MASK1 /tmp/install.conf | awk '{print $3}'`
GW=`grep GW /tmp/install.conf | awk '{print $3}'`
HOST=`grep HOST /tmp/install.conf | awk '{print $3}'`
DOMAIN=`grep DOMAIN /tmp/install.conf | awk '{print $3}'`
DISK1=`grep DISK1 /tmp/install.conf | awk '{print $3}'`
PARTDISK=`grep PARTDISK /tmp/install.conf | awk '{print $3}'`
# Console dialog
red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)


# Установка свежего среза портеджей
for i in 'Установка свежего среза портеджей...'; do printf "$i\r"; done
emerge-webrsync > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Настройка профиля
for i in 'Настройка профиля системы...'; do printf "$i\r"; done
eselect profile set default/linux/amd64/13.0 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка часового пояса
for i in 'Настройка часового пояса...'; do printf "$i\r"; done
echo "Europe/Moscow" > /etc/timezone
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Применение настроек временной зоны
for i in 'Применение настроек временной зоны...'; do printf "$i\r"; done
emerge --config sys-libs/timezone-data > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка параметров локализации
for i in 'Настройка параметров локализации...'; do printf "$i\r"; done
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Генерация профилей локализации
for i in 'Генерация профилей локализации...'; do printf "$i\r"; done
locale-gen > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Выбор профиля локализации
for i in 'Выбор профиля локализации...'; do printf "$i\r"; done
eselect locale set ru_RU.UTF-8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Обновление переменных окружения
for i in 'Обновление переменных окружения...'; do printf "$i\r"; done
env-update && source /etc/profile > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Установка исходных кодов ядра
for i in 'Установка исходных кодов ядра...'; do printf "$i\r"; done
emerge -q sys-kernel/gentoo-sources > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка ядра
for i in 'Настройка ядра...'; do printf "$i\r"; done
cd /usr/src/linux > /dev/null 2>&1
wget public.t-brain.ru/conf/kernel -O /usr/src/linux/.config > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Сборка нового ядра
for i in 'Сборка нового ядра...'; do printf "$i\r"; done
make  > /dev/null 2>&1
make modules_install > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Установка нового ядра
for i in 'Установка нового ядра...'; do printf "$i\r"; done
make install > /dev/null 2>&1
mkdir -p /boot/efi/boot > /dev/null 2>&1
cp /boot/vmlinuz* /boot/efi/boot/bootx64.efi > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка файловых систем
for i in 'Настройка файловых систем...'; do printf "$i\r"; done
echo $DISK1[2]   /boot        ext4    defaults,noatime     0 2 > /etc/fstab
echo $DISK1[3]   none         swap    sw                   0 0 >> /etc/fstab
echo $DISK1[4]   /            ext4    noatime              0 1 >> /etc/fstab
echo  >> /etc/fstab
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка параметров имени комптютера
for i in 'Настройка параметров имени системы в сети...'; do printf "$i\r"; done
echo "hostname=\"$HOST\"" > /etc/conf.d/hostname
echo "127.0.0.1       $HOST.$DOMAIN $HOST" > /etc/hosts
echo "127.0.0.1       $HOST.$DOMAIN." >> /etc/hosts
echo "127.0.0.1       localhost" >> /etc/hosts
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка параметров сети
for i in 'Настройка параметров сети...'; do printf "$i\r"; done
echo "dns_domain_lo=\"$DOMAIN\"" > /etc/conf.d/net
echo "config_$Lan1=\"$IP1 netmask $MASK1\"" >> /etc/conf.d/net
echo "routes_$Lan1=\"default via $GW\"" >> /etc/conf.d/net
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Добавление в автозапуск сетевого адартора
for i in 'Добавление в автозапуск сетевого адартора...'; do printf "$i\r"; done
cd /etc/init.d > /dev/null 2>&1
ln -s net.lo net.$Lan1 > /dev/null 2>&1
rc-update add net.$Lan1 default > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Назначение пароля суперпользователю
for i in 'Назначение пароля суперпользователю...'; do printf "$i\r"; done
usermod -p '$6$h9mmuWBb$uOoOa81m4BXXaMUX5N069SoXblyD9/38Xf2v1BTdIE.kaA2AWhCpZyT9tdnaZsqTFIzT79kTv6iCdYO6yMjzF.' root > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Компонент для ведения системных логов
for i in 'Установка службы ведения системных логов...'; do printf "$i\r"; done
emerge -q app-admin/syslog-ng > /dev/null 2>&1
rc-update add syslog-ng default > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Планировщик заданий
for i in 'Установка планировщика заданий...'; do printf "$i\r"; done
emerge -q sys-process/cronie > /dev/null 2>&1
rc-update add cronie default > /dev/null 2>&1
crontab /etc/crontab > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

#Индексация файлов
for i in 'Установка службы индексации файлов...'; do printf "$i\r"; done
emerge -q sys-apps/mlocate > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

#Удаленный доступ
for i in 'Добавление службы SSH в автозагрузку...'; do printf "$i\r"; done
rc-update add sshd default > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Grub
for i in 'Сборка загрузчика операционной системы...'; do printf "$i\r"; done
emerge -q sys-boot/grub > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Установка загрузчика операционной системы...'; do printf "$i\r"; done
grub2-install $DISK1 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Настройка загрузчика операционной системы...'; do printf "$i\r"; done
grub2-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

exit
