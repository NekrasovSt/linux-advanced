#!/bin/bash

# файл конфига
cat > /etc/sysconfig/otus.config << EOF
LFILE=/var/log/messages
PATTERN=eth0
EOF
# файл сервиса
cat > /etc/systemd/system/otus-unit.service << EOF1
[Unit]
Description=Парсим лог
Wants=otus-unit.timer

[Service]
EnvironmentFile=/etc/sysconfig/otus.config
Type=oneshot
ExecStart=/usr/bin/grep \$PATTERN \$LFILE

[Install]
WantedBy=multi-user.target
EOF1
# файл Таймера
cat > /etc/systemd/system/otus-unit.timer << EOF2
[Unit]
Description=Запуск парсинга лога
Requires=otus-unit.service

[Timer]
Unit=otus-unit.service
OnCalendar=*:*:0,30

[Install]
WantedBy=timers.target
EOF2

systemctl enable otus-unit.service
systemctl start otus-unit.service

# Установка spawn-fcgi
yum install -y epel-release spawn-fcgi php-cli httpd

cat > /etc/sysconfig/spawn-fcgi << EOF3
OPTIONS=-u apache -g apache -s /var/run/spawn-fcgi/php-fcgi.sock -S -M 0600 -C 32 -F 1 -P /var/run/spawn-fcgi/spawn-fcgi.pid -- /usr/bin/php-cgi
EOF3

cat > /etc/systemd/system/spawn-fcgi.service << EOF4
[Unit]
Description=Spawn-fsgi service
After=network.target

[Service]
Type=forking
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi \$OPTIONS
PIDFile=/var/run/spawn-fcgi/spawn-fcgi.pid
RuntimeDirectory=spawn-fcgi

[Install]
WantedBy=multi-user.target
EOF4

systemctl enable spawn-fcgi.service
systemctl start spawn-fcgi.service

setenforce 0
#Настройка httpd на разные конфиги
cp /usr/lib/systemd/system/httpd.service /etc/systemd/system/httpd@.service
sed -i 's*EnvironmentFile=/etc/sysconfig/httpd*EnvironmentFile=/etc/sysconfig/%i*' /etc/systemd/system/httpd@.service
cp /etc/sysconfig/httpd /etc/sysconfig/conf1
cp /etc/sysconfig/httpd /etc/sysconfig/conf2
sed -i 's*#OPTIONS=*OPTIONS=-f /etc/httpd/conf/httpd1.conf*' /etc/sysconfig/conf1
sed -i 's*#OPTIONS=*OPTIONS=-f /etc/httpd/conf/httpd2.conf*' /etc/sysconfig/conf2
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd1.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd2.conf
sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd1.conf
sed -i 's/Listen 80/Listen 8090/' /etc/httpd/conf/httpd2.conf
echo "PidFile /var/run/httpd/httpd1.pid" >> /etc/httpd/conf/httpd1.conf
echo "PidFile /var/run/httpd/httpd2.pid" >> /etc/httpd/conf/httpd2.conf

systemctl enable --now httpd@conf1.service
systemctl enable --now httpd@conf2.service