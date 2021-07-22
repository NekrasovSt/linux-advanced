# **Введение**

Домашнее задание по теме "Сбор и анализ логов"


# **Запуск**

```
vagrant up
vagrant ssh ansible
```

Переходим в папку с плейбуками и запускаем.

```
cd /share
vagrant ssh ansible
vagrant@ansible:/share$ ansible-playbook instal-log.yml
vagrant@ansible:/share$ ansible-playbook instal-web.yml
```

Переходим на сервер логов и смотрим.

```
vagrant ssh log
[root@log vagrant]# journalctl -D /var/log/journal/remote --follow
-- Logs begin at Wed 2021-07-21 17:27:35 UTC. --
Jul 21 17:33:56 web sshd[3211]: Disconnected from 192.168.50.13 port 39056
Jul 21 17:33:56 web sshd[3207]: pam_unix(sshd:session): session closed for user vagrant
Jul 21 17:33:56 web systemd-logind[366]: Removed session 4.
Jul 21 17:35:13 web sudo[4761]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/su
Jul 21 17:35:13 web sudo[4761]: pam_unix(sudo:session): session opened for user root by vagrant(uid=0)
Jul 21 17:35:13 web su[4763]: (to root) vagrant on pts/0
Jul 21 17:35:13 web su[4763]: pam_unix(su:session): session opened for user root by vagrant(uid=0)    
Jul 21 17:39:45 web chronyd[379]: Selected source 83.167.27.4
Jul 21 17:42:53 web systemd[1]: Starting Cleanup of Temporary Directories...
Jul 21 17:42:53 web systemd[1]: Started Cleanup of Temporary Directories.
```