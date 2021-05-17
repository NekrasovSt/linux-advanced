# **Введение**

Домашнее задание для урока "NFS,FUSE"

# **Запуск сервера**

```
vagrant up nfss
vagrant ssh nfss    
```
Настройка NFS выполняется в блоке 

```
nfss.vm.provision "shell"
```
1. Создание расшареной папки
2. Настройка /etc/exports
3. Добавление правил фаервола

Проверяем настройки

```
[root@nfss ~]# exportfs
/var/upload     <world>
[root@nfss ~]# exportfs -s
/var/upload  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)

```

# **Запуск клиента**

Настройка NFS выполняется в блоке 

```
nfsс.vm.provision "shell"
```

Папка примонтирована к /mnt/upload

```
[root@nfsc ~]# touch /mnt/upload/tmp
[root@nfsc ~]# ls /mnt/upload/
tmp
```
Перезагрузим и проверим что все работает, монтирование происходит после первого обращения к директории.

```
[root@nfsc ~]# df -hT
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  111M     0  111M   0% /dev
tmpfs          tmpfs     118M     0  118M   0% /dev/shm
tmpfs          tmpfs     118M  4.5M  114M   4% /run
tmpfs          tmpfs     118M     0  118M   0% /sys/fs/cgroup
/dev/sda1      xfs        40G  3.0G   38G   8% /
tmpfs          tmpfs      24M     0   24M   0% /run/user/1000
[root@nfsc ~]# ls /mnt/upload/
tmp
[root@nfsc ~]# df -hT
Filesystem                Type      Size  Used Avail Use% Mounted on
devtmpfs                  devtmpfs  111M     0  111M   0% /dev
tmpfs                     tmpfs     118M     0  118M   0% /dev/shm
tmpfs                     tmpfs     118M  4.5M  114M   4% /run
tmpfs                     tmpfs     118M     0  118M   0% /sys/fs/cgroup
/dev/sda1                 xfs        40G  3.0G   38G   8% /
tmpfs                     tmpfs      24M     0   24M   0% /run/user/1000
192.168.50.10:/var/upload nfs4       40G  3.1G   37G   8% /mnt/upload
```

