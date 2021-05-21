# **Введение**

Домашнее задание для урока "Управление пакетами. Дистрибьюция софта"

# **Запуск**

```
vagrant up
vagrant ssh    
```
В Vagrantfile производится основые операции в скрипте 

```
nfss.vm.provision "shell",
name: "Setup",
path: "setup.sh" 
```
1. Установка зависимостей
2. Скачивание и разбор пакета nginx
3. Модификация
4. Сборка

Убедится что пакет собран сможно в папке

```
[root@nfss vagrant]# ls /root/rpmbuild/RPMS/x86_64/
nginx-1.14.1-1.el7_4.ngx.x86_64.rpm  nginx-debuginfo-1.14.1-1.el7_4.ngx.x86_64.rpm
```

Далее установим модифицированный ngnix

```
[root@nfss vagrant]# yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
...
[root@nfss vagrant]# systemctl start nginx
[root@nfss vagrant]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-05-21 08:11:31 UTC; 9s ago
     Docs: http://nginx.org/en/docs/
  Process: 22159 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 22160 (nginx)
   CGroup: /system.slice/nginx.service
           ├─22160 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           └─22161 nginx: worker process

May 21 08:11:31 nfss systemd[1]: Starting nginx - high performance web server...
May 21 08:11:31 nfss systemd[1]: Can't open PID file /var/run/nginx.pid (yet?) after start: No such file or directory
May 21 08:11:31 nfss systemd[1]: Started nginx - high performance web server.
```

# **Создание репозитория**

Репозиторий создается в скрипте командой
```
[root@nfss vagrant]# createrepo /usr/share/nginx/html/repo/
Spawning worker 0 with 1 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs 
```
Изменим конфиг nginx
``
location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
    autoindex on;
}

```
Перезагрузим nginx

```
[root@nfss vagrant]# nginx -t && nginx -s reload
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Проверяем что репозиторий добавлен
```
[root@nfss vagrant]# yum repolist enabled | grep otus
otus                                otus-linux   
```