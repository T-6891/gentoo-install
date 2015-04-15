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

