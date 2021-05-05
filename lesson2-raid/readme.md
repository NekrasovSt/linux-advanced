# **Введение**

Домашнее задание для урока "Дисковая подсистема"

# **Запуск**

```
vagrant up
vagrant ssh    
```
1. После запуска будет добавлено четыре диска.
2. Собран RAID 5 массив.
3. Сформированы 5 GPT партиций.

Скрипт помещен в секцию 

```
box.vm.provision "shell"
```

Для просморта состояния дисков можно использовать lsblk

```
lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda         8:0    0   40G  0 disk
└─sda1      8:1    0   40G  0 part  /
sdb         8:16   0  250M  0 disk
└─md0       9:0    0  496M  0 raid5
  ├─md0p1 259:0    0   98M  0 md    /raid/part1
  ├─md0p2 259:1    0   99M  0 md    /raid/part2
  ├─md0p3 259:2    0  100M  0 md    /raid/part3
  ├─md0p4 259:3    0   99M  0 md    /raid/part4
  └─md0p5 259:4    0   98M  0 md    /raid/part5
sdc         8:32   0  250M  0 disk
└─md0       9:0    0  496M  0 raid5
  ├─md0p1 259:0    0   98M  0 md    /raid/part1
  ├─md0p2 259:1    0   99M  0 md    /raid/part2
  ├─md0p3 259:2    0  100M  0 md    /raid/part3
  ├─md0p4 259:3    0   99M  0 md    /raid/part4
  └─md0p5 259:4    0   98M  0 md    /raid/part5
sdd         8:48   0  250M  0 disk
└─md0       9:0    0  496M  0 raid5
  ├─md0p1 259:0    0   98M  0 md    /raid/part1
  ├─md0p2 259:1    0   99M  0 md    /raid/part2
  ├─md0p3 259:2    0  100M  0 md    /raid/part3
  ├─md0p4 259:3    0   99M  0 md    /raid/part4
  └─md0p5 259:4    0   98M  0 md    /raid/part5
sde         8:64   0  250M  0 disk
```

# **Ломаем/чиним массив**

Файлим диск

```
mdadm /dev/md0 --fail /dev/sdс
```
Видим что один диск "выпал".

```
cat /proc/mdstat
```

Извлекаем и меняем диск.

```
mdadm /dev/md0 --remove /dev/sdс
mdadm /dev/md0 --add /dev/sdс
```

Ждем пока пройдет восстановление и убеждаемся, что все работает.


```
cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdc[4] sdd[3] sdb[0]
      507904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
```