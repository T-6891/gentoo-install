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

# Сброс
#Color_Off='\e[0m'       # Text Reset

# Обычные цвета
#Black='\e[0;30m'        # Black
#Red='\e[0;31m'          # Red
#Green='\e[0;32m'        # Green
#Yellow='\e[0;33m'       # Yellow
#Blue='\e[0;34m'         # Blue
#Purple='\e[0;35m'       # Purple
#Cyan='\e[0;36m'         # Cyan
#White='\e[0;37m'        # White

# Жирные
#BBlack='\e[1;30m'       # Black
#BRed='\e[1;31m'         # Red
#BGreen='\e[1;32m'       # Green
#BYellow='\e[1;33m'      # Yellow
#BBlue='\e[1;34m'        # Blue
#BPurple='\e[1;35m'      # Purple
#BCyan='\e[1;36m'        # Cyan
#BWhite='\e[1;37m'       # White

# Подчёркнутые
#UBlack='\e[4;30m'       # Black
#URed='\e[4;31m'         # Red
#UGreen='\e[4;32m'       # Green
#UYellow='\e[4;33m'      # Yellow
#UBlue='\e[4;34m'        # Blue
#UPurple='\e[4;35m'      # Purple
#UCyan='\e[4;36m'        # Cyan
#UWhite='\e[4;37m'       # White

# Фоновые
#On_Black='\e[40m'       # Black
#On_Red='\e[41m'         # Red
#On_Green='\e[42m'       # Green
#On_Yellow='\e[43m'      # Yellow
#On_Blue='\e[44m'        # Blue
#On_Purple='\e[45m'      # Purple
#On_Cyan='\e[46m'        # Cyan
#On_White='\e[47m'       # White

# Высоко Интенсивные
#IBlack='\e[0;90m'       # Black
#IRed='\e[0;91m'         # Red
#IGreen='\e[0;92m'       # Green
#IYellow='\e[0;93m'      # Yellow
#IBlue='\e[0;94m'        # Blue
#IPurple='\e[0;95m'      # Purple
#ICyan='\e[0;96m'        # Cyan
#IWhite='\e[0;97m'       # White

# Жирные Высоко Интенсивные
#BIBlack='\e[1;90m'      # Black
#BIRed='\e[1;91m'        # Red
#BIGreen='\e[1;92m'      # Green
#BIYellow='\e[1;93m'     # Yellow
#BIBlue='\e[1;94m'       # Blue
#BIPurple='\e[1;95m'     # Purple
#BICyan='\e[1;96m'       # Cyan
#BIWhite='\e[1;97m'      # White

# Высоко Интенсивные фоновые
#On_IBlack='\e[0;100m'   # Black
#On_IRed='\e[0;101m'     # Red
#On_IGreen='\e[0;102m'   # Green
#On_IYellow='\e[0;103m'  # Yellow
#On_IBlue='\e[0;104m'    # Blue
#On_IPurple='\e[0;105m'  # Purple
#On_ICyan='\e[0;106m'    # Cyan
#On_IWhite='\e[0;107m'   # White



clear
sleep 1
echo '###################################################################'
echo ''
echo '          ______ _______ __   _ _______  _____   _____'
echo '         |  ____ |______ | \  |    |    |     | |     |'
echo '         |_____| |______ |  \_|    |    |_____| |_____|'
echo ''
echo '                    _____ __   _ _     _ _     _'
echo '             |        |   | \  | |     |  \___/'
echo '             |_____ __|__ |  \_| |_____| _/   \_'
echo ''
echo ''
echo '###################################################################'
sleep 5
echo ''
echo ''
# Разметка диска
for i in 'Creating disk partitions...'; do printf "$i\r"; done
if [ "$PARTDISK" == "FS" ]
then
        PARTDISKSCHEME="/tmp/gentoo-install/conf/fs.conf"
else
        PARTDISKSCHEME="/tmp/gentoo-install/conf/lvm.conf"
fi

while read line
do
parted -sa optimal $DISK1 "$line"   > /dev/null 2>&1
done < $PARTDISKSCHEME
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
    echo 'A critical error has occurred! The installation cannot continue...'
fi
echo -n "${reset}"
echo

# Форматирование разделов
for i in 'Formatting partitions...'; do printf "$i\r"; done
mkfs.fat -F 32  $DISK1[2]  > /dev/null 2>&1
mkfs.ext4 $DISK1[4]  > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Активация раздела подкачки
for i in 'Activate the swap partition...'; do printf "$i\r"; done
mkswap $DISK1[3] > /dev/null 2>&1
swapon $DISK1[3] > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Монтирование
for i in 'Mounting partitions...'; do printf "$i\r"; done
mount $DISK1'4' /mnt/gentoo > /dev/null 2>&1
mkdir /mnt/gentoo/boot > /dev/null 2>&1
mount $DISK1'2' /mnt/gentoo/boot > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Синхронизация времени
for i in 'Time synchronization...'; do printf "$i\r"; done
ntpd -q -g  > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo



# Загрузка свежего среза системы
for i in 'The download of the actual slice system...'; do printf "$i\r"; done
cd /mnt/gentoo  > /dev/null 2>&1
wget https://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/`links -source https://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/latest-stage3-amd64.txt | grep stage3 | awk '{print $1}'`  > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

for i in 'Unpacking the archive...'; do printf "$i\r"; done
tar xpvf stage3-*.tar.xz  > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo


# Настройка опции компиляции
for i in 'Configure the compilation option...'; do printf "$i\r"; done
echo 'CFLAGS="-march=native -O2 -pipe"' > $MAKECONF
echo 'CXXFLAGS="${CFLAGS}"' >> $MAKECONF
echo 'CHOST="x86_64-pc-linux-gnu"' >> $MAKECONF
echo " " >> $MAKECONF
echo 'USE="-ipv6 -X -cups -alsa bindist acl sockets symlink vim-syntax unicode"' >> $MAKECONF
echo " " >> $MAKECONF
echo 'PORTDIR="/usr/portage"' >> $MAKECONF
echo 'DISTDIR="${PORTDIR}/distfiles"' >> $MAKECONF
echo 'PKGDIR="${PORTDIR}/packages"' >> $MAKECONF
echo " " >> $MAKECONF
echo MAKEOPTS=\"-j$((`cat /proc/cpuinfo | grep processor | wc -l` + 1))\" >> $MAKECONF
echo " " >> $MAKECONF
echo 'GENTOO_MIRRORS="https://mirror.yandex.ru/gentoo-distfiles/"' >> $MAKECONF
echo " " >> $MAKECONF
mkdir --parents /mnt/gentoo/etc/portage/repos.conf > /dev/null 2>&1
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Копирование DNS настроек
for i in 'Copying the DNS settings...'; do printf "$i\r"; done
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Копирование конфигурационных файлов
for i in 'Copying configuration files...'; do printf "$i\r"; done
cp /tmp/gentoo-install/install.conf /mnt/gentoo/tmp/install.conf > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Монтирование необходимых файловых систем
for i in 'Mount the necessary file systems...'; do printf "$i\r"; done
mount --types proc /proc /mnt/gentoo/proc > /dev/null 2>&1
mount --rbind /sys /mnt/gentoo/sys > /dev/null 2>&1
mount --make-rslave /mnt/gentoo/sys > /dev/null 2>&1
mount --rbind /dev /mnt/gentoo/dev > /dev/null 2>&1
mount --make-rslave /mnt/gentoo/dev > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

# Переход в новое окружение (chroot)
for i in 'Transition to a new environment (chroot)...'; do printf "$i\r"; done
cp /tmp/gentoo-install/part-b.sh /mnt/gentoo/tmp/ > /dev/null 2>&1
cp /tmp/gentoo-install/conf/kernel /mnt/gentoo/tmp/ > /dev/null 2>&1
cd /mnt/gentoo/tmp/ > /dev/null 2>&1
chmod +x ./part-b.sh > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo

chroot /mnt/gentoo /bin/bash -c /tmp/part-b.sh


# Перезагрузка
for i in 'System restart...'; do printf "$i\r"; done
cd > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -n  "${toend}${reset}[${green}OK${reset}]"
else
    echo -n  "${toend}${reset}[${red}fail${reset}]"
fi
echo -n "${reset}"
echo
echo '###################################################################'
echo " "
echo 'The installation is now complete!' 
echo " "
sleep 1
echo "The system will restart" 
echo " "
sleep 1
read -p "Press any key [${red}enter${reset}] ..."
reboot
 
