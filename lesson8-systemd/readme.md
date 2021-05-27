# **Введение**

Инициализация системы. Systemd

# **Запуск**

```
vagrant up
```

# **Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова**

Основная часть в полняется в установочном файле setup.sh
1. Создается конфиг файл /etc/sysconfig/otus.config
2. Создается сервис /etc/systemd/system/otus-unit.service
3. Создается таймер /etc/systemd/system/otus-unit.timer
4. Запуск таймера

Проверить можно запросив комаду, с переодичность 30+ сек.

```
[root@kernel-update ~]# systemctl status otus-unit.service
● otus-unit.service - Парсим лог
   Loaded: loaded (/etc/systemd/system/otus-unit.service; enabled; vendor preset: disabled)
   Active: inactive (dead) since Thu 2021-05-27 05:52:46 UTC; 8s ago
  Process: 22732 ExecStart=/usr/bin/grep $PATTERN $LFILE (code=exited, status=0/SUCCESS)
 Main PID: 22732 (code=exited, status=0/SUCCESS)

May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...10.0.2.3'May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...'ussc.ru'May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05... -> boundMay 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...'assume')May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...'assume')May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...'assume')May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...g and DNSMay 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...ctivated.May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05... scripts)May 27 05:52:47 kernel-update grep[22732]: May 27 05:51:55 localhost grep: May 27 05:49:47 localhost grep: May 27 05:49:00 localhost grep: May 27 05...cripts...Hint: Some lines were ellipsized, use -l to show in full.
```
Время последнего запуска меняется и присутсвует результат парсинга.

# **Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi)**

Основная часть в полняется в установочном файле setup.sh
1. Установка зависимостей
2. Создание конфиг файла /etc/sysconfig/spawn-fcgi
3. Создание юнита /etc/systemd/system/spawn-fcgi.service
4. Запуск

Для проверки убедимся что сервис запустился
```
[root@kernel-update ~]# systemctl status spawn-fcgi.service
● spawn-fcgi.service - Spawn-fsgi service
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-05-27 08:07:56 UTC; 40s ago
  Process: 24571 ExecStart=/usr/bin/spawn-fcgi $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 24572 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
   ...
```

# **Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами**
Основная часть в полняется в установочном файле setup.sh
1. Подготовка конфигов /etc/sysconfig/conf1 и /etc/sysconfig/conf2
2. Подготовка конфигов /etc/httpd/conf/httpd1.conf и /etc/httpd/conf/httpd2.conf
3. Запуск двух экземпляров httpd

Проверяем 

```
[root@kernel-update ~]# systemctl status httpd@conf1.service
● httpd@conf1.service - The Apache HTTP Server
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-05-27 08:57:53 UTC; 6min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 25078 (httpd)
   Status: "Total requests: 1; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@conf1.service
   ...
[root@kernel-update ~]# systemctl status httpd@conf2.service
● httpd@conf2.service - The Apache HTTP Server
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-05-27 08:58:00 UTC; 7min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 25102 (httpd)
   Status: "Total requests: 1; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@conf2.service
```



