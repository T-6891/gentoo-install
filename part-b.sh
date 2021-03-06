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

# Создание конфигурационных файлов системы управления портеджами
for i in 'To create a configuration file management system portage...'; do printf "$i\r"; done
touch /etc/portage/package.license  > /dev/null 2>&1
touch /etc/portage/package.keywords  > /dev/null 2>&1
touch /etc/portage/package.unmask  > /dev/null 2>&1
touch /etc/portage/package.mask > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Установка свежего среза портеджей
for i in 'Installation of a fresh cut of portages...'; do printf "$i\r"; done
emerge-webrsync > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Настройка профиля системы
for i in 'Configuring the system profile...'; do printf "$i\r"; done
eselect profile set default/linux/amd64/17.0 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка часового пояса
for i in 'Setting the time zone...'; do printf "$i\r"; done
echo "Europe/Moscow" > /etc/timezone 
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Применение настроек временной зоны
for i in 'Apply time zone settings...'; do printf "$i\r"; done
emerge --config sys-libs/timezone-data > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка параметров локализации
for i in 'Setting localization parameters...'; do printf "$i\r"; done
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
echo 'ru_RU.UTF-8 UTF-8' >> /etc/locale.gen
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Генерация профилей локализации
for i in 'Generation of localization profiles...'; do printf "$i\r"; done
locale-gen > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Выбор профиля локализации
for i in 'Select a localization profile...'; do printf "$i\r"; done
eselect locale set ru_RU.UTF-8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Выбор профиля локализации
for i in 'Optimization of the control input history...'; do printf "$i\r"; done
echo  ' ' >> /etc/inputrc
echo  '# map "page up" and "page down" to search history based on current cmdline' >> /etc/inputrc
echo  '"\e[5~": history-search-backward' >> /etc/inputrc
echo  '"\e[6~": history-search-forward'  >> /etc/inputrc
echo  ' ' >> /etc/inputrc
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Обновление переменных окружения
for i in 'Updating environment variables...'; do printf "$i\r"; done
env-update > /dev/null 2>&1
source /etc/profile > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Установка исходных кодов ядра
for i in 'Installing kernel source codes...'; do printf "$i\r"; done
emerge -q sys-kernel/gentoo-sources > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Установка genkernel
for i in 'Installig genkernel..'; do printf "$i\r"; done
echo "sys-apps/util-linux static-libs" >> /etc/portage/package.use/util-linux
echo 'sys-kernel/linux-firmware linux-fw-redistributable no-source-code' > /etc/portage/package.license
emerge -q sys-kernel/genkernel > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Сборка ядра
for i in 'Using genkernel..'; do printf "$i\r"; done
genkernel all > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Установка файлов прошивки 
for i in 'Installing firmware files...'; do printf "$i\r"; done
emerge -q sys-kernel/linux-firmware > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Настройка файловых систем
for i in 'Configuring file systems...'; do printf "$i\r"; done
echo `blkid | grep 'PARTLABEL="boot"' | awk '{print $2}'`   /boot   vfat    defaults,noatime     0 2 > /etc/fstab
echo `blkid | grep 'PARTLABEL="swap"' | awk '{print $2}'`   none         swap    sw                   0 0 >> /etc/fstab
echo `blkid | grep 'PARTLABEL="rootfs"' | awk '{print $2}'`   /            ext4    noatime              0 1 >> /etc/fstab
echo  >> /etc/fstab
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Настройка параметров имени компьютера
for i in 'Configure system name settings on the network...'; do printf "$i\r"; done
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
for i in 'Configure the network settings...'; do printf "$i\r"; done
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
for i in 'Adding a network adapter to autorun...'; do printf "$i\r"; done
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
for i in 'Assign a superuser password...'; do printf "$i\r"; done
usermod -p '$6$h9mmuWBb$uOoOa81m4BXXaMUX5N069SoXblyD9/38Xf2v1BTdIE.kaA2AWhCpZyT9tdnaZsqTFIzT79kTv6iCdYO6yMjzF.' root > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Компонент для ведения системных логов
for i in 'Installing the system log service...'; do printf "$i\r"; done
emerge -q app-admin/sysklogd > /dev/null 2>&1
rc-update add sysklogd default > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Планировщик заданий
for i in 'Install the task scheduler...'; do printf "$i\r"; done
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
for i in 'Installing the file indexing service...'; do printf "$i\r"; done
emerge -q sys-apps/mlocate > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installation eix  ...'; do printf "$i\r"; done
emerge -q app-portage/eix > /dev/null 2>&1
eix-sync > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the Vim editor ...'; do printf "$i\r"; done
emerge -q app-editors/vim > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the Midnight Commander file Manager...'; do printf "$i\r"; done
emerge -q app-misc/mc > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the htop process monitor...'; do printf "$i\r"; done
emerge -q sys-process/htop > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the atop process monitor...'; do printf "$i\r"; done
emerge -q sys-process/atop > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the Glances process monitor...'; do printf "$i\r"; done
emerge -q sys-process/glances > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the nload network interface load monitor...'; do printf "$i\r"; done
emerge -q net-analyzer/nload > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'To install a console multiplexer like Screen...'; do printf "$i\r"; done
emerge -q app-misc/screen > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the sudo component...'; do printf "$i\r"; done
emerge -q app-admin/sudo > /dev/null 2>&1
echo  "%wheel ALL=(ALL) ALL" >> /etc/sudoers
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the gentoolkit component ...'; do printf "$i\r"; done
emerge -q app-portage/gentoolkit > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the pciutils component ...'; do printf "$i\r"; done
emerge -q sys-apps/pciutils > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the usbutils component ...'; do printf "$i\r"; done
emerge -q sys-apps/usbutils > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the sysstat component ...'; do printf "$i\r"; done
emerge -q app-admin/sysstat > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installation of netcat ...'; do printf "$i\r"; done
emerge -q net-analyzer/netcat > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installation of Telnet ...'; do printf "$i\r"; done
emerge -q net-misc/telnet-bsd > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installation of IPTables ...'; do printf "$i\r"; done
emerge -q net-firewall/iptables > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'The installation of the bzip2 archiver ...'; do printf "$i\r"; done
emerge -q app-arch/pbzip2 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Install unzip archiver ...'; do printf "$i\r"; done
emerge -q app-arch/unzip > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the lftp console FTP client ...'; do printf "$i\r"; done
emerge -q net-ftp/lftp > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the lsof component ...'; do printf "$i\r"; done
emerge -q sys-process/lsof > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the ncdu component ...'; do printf "$i\r"; done
emerge -q sys-fs/ncdu > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the LZ4 archiver ...'; do printf "$i\r"; done
emerge -q app-arch/lz4 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing a utility for analyzing iotop disk bandwidth consumption ...'; do printf "$i\r"; done
emerge -q sys-process/iotop > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the iptstate network session monitor ...'; do printf "$i\r"; done
emerge -q net-analyzer/iptstate > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the MTR network diagnostic tool...'; do printf "$i\r"; done
emerge -q net-analyzer/mtr > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the ntp client...'; do printf "$i\r"; done
emerge -q net-misc/ntp > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the git version control system...'; do printf "$i\r"; done
emerge -q dev-vcs/git > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the ccze log file formatting system ...'; do printf "$i\r"; done
emerge -q app-admin/ccze > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing Telegraf (agent for collecting & reporting metrics)'; do printf "$i\r"; done
echo "net-analyzer/telegraf ~amd64" >> /etc/portage/package.keywords
emerge -q net-analyzer/telegraf > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

#Удаленный доступ
for i in 'Adding the SSH service to startup...'; do printf "$i\r"; done
sed -r 's/#*\s*PermitRootLogin prohibit-password/PermitRootLogin yes/g' -i /etc/ssh/sshd_config
rc-update add sshd default > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Grub
for i in 'Build the operating system loader...'; do printf "$i\r"; done
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge -q sys-boot/grub:2 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Installing the operating system loader...'; do printf "$i\r"; done
grub-install --target=x86_64-efi --efi-directory=/boot > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Configuring the operating system bootloader...'; do printf "$i\r"; done
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

rm -rf /stage3-*.tar.*

exit
