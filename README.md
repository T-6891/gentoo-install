Gentoo Linux - Это отличный дистрибутив Linux, в котором сделан упор на гибкость настройки, удобства управления системой и оптимизацию производительности под используемое оборудование. Но когда приходится совершать большое количество установок на  разные сервера, большое количество рутиной работы, которую можно автоматизировать и пустить свободное время на более полезные вещи, оставив заниматься базовыми вещами скрипту автоматической установки =)
Описание

Что представляет из себя скрипт авто установки?

    * Мастер первоначальной настройки конфигурации
    * Подготовка оборудования
    * Загрузка последнего среза системы
    * Обновление дерева портеджей
    * Сборка и установка последних версий необходимого для начала работы прикладного ПО
    * Настройка системы
    * Установка загрузчика


Подготовка
----------

Для нормальной работы вам необходимы следующие компоненты

    * Сервер \ рабочая станция
    * CD привод (IDE\SATA\SAS\USB\Virtual)
    * Сеть (10\100\1000 мб\с)
    * Доступ в интернет
    * LiveCD Gentoo Linux (admincd-amd64-*.iso )


Настройка
---------

Выполнить следующий порядок действий

    * Загрузиться с LiveCD
    * Настроить сеть
    * Проверить наличие доступа в интернет
    * Задать пароль суперпользователя
    * Запустить ssh службу
    * Со своего терминала подключиться по ssh к серверу
    * Выполнить команды установки


Установка
---------

Загрузка инсталлятора

```
cd /tmp
wget http://public.t-brain.ru/gentoo-install/install.sh
chmod +x
```

Запуск

```
./install.sh
```

Далее следовать указаниям мастера настройки.

Вам будет предложено ввести следующие данные -

    * Настройка сетевого интерфейса
    * Имя хоста
    * Домен
    * Выбор разбивки диска
    * Вывод введенных настроек
    * Ожидания подтверждения установки

После подтверждения установка начнется и будет проходить в автоматическом режиме.


Проверка
--------

Для проверки необходимо выполнить:

    Дождаться окончания установки
    В на экране терминала будет выведен лог и статус процесса установки
    Все пункты должны иметь значение - [OK] , в противном случае что то пошло не так и установленная система может работать не корректно.
    Если все в норме, удовлетворить запрос системы на перезагрузку.
    После перезагрузки подключиться к серверу по ssh используя указанные сетевые настройки и пароль для супер пользователя - 951753456852+
    Сменить пароль суперпользователя
    Система готова!


