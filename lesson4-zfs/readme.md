# **Введение**

Домашнее задание для урока "Файловая система и LVM"

# **Запуск**

```
vagrant up
vagrant ssh    
```
# **Определить алгоритм с наилучшим сжатием**

Создаем пул
```
[root@server ~]# zpool create pool sdb
[root@server ~]# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
pool   960M  94.5K   960M        -         -     0%     0%  1.00x    ONLINE  -
```
Создаем файловые системы со сжатием

```
[root@server ~]# zfs create pool/gzip
[root@server ~]# zfs create pool/gzip-N
[root@server ~]# zfs create pool/zle
[root@server ~]# zfs create pool/lzjb
[root@server ~]# zfs create pool/lz4
[root@server ~]# zfs list
NAME          USED  AVAIL     REFER  MOUNTPOINT
pool          234K   832M     28.5K  /pool
pool/gzip      24K   832M       24K  /pool/gzip
pool/gzip-N    24K   832M       24K  /pool/gzip-N
pool/lz4       24K   832M       24K  /pool/lz4
pool/lzjb      24K   832M       24K  /pool/lzjb
pool/zle       24K   832M       24K  /pool/zle
[root@server ~]# zfs set compression=gzip pool/gzip
[root@server ~]# zfs set compression=gzip-5 pool/gzip-N
[root@server ~]# zfs set compression=lz4 pool/lz4
[root@server ~]# zfs set compression=lzjb pool/lzjb
[root@server ~]# zfs set compression=zle pool/zle
```
Уопируем и проверяем сжатие
```
[root@server ~]# cp War_and_Peace.txt /pool/gzip
[root@server ~]# cp War_and_Peace.txt /pool/gzip-N
[root@server ~]# cp War_and_Peace.txt /pool/lz4
[root@server ~]# cp War_and_Peace.txt /pool/lzjb
[root@server ~]# cp War_and_Peace.txt /pool/zle

[root@server ~]# zfs get compressratio
NAME         PROPERTY       VALUE  SOURCE
pool         compressratio  1.08x  -
pool/gzip    compressratio  1.08x  -
pool/gzip-N  compressratio  1.08x  -
pool/lz4     compressratio  1.08x  -
pool/lzjb    compressratio  1.07x  -
pool/zle     compressratio  1.08x  -

```

Вывод: для текста уровень сжатия сопоставим.

# **Определить настройки пула**

Импортим пул

```
zpool import -d zpoolexport/ -N otus
[root@server ~]# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus   480M  2.12M   478M        -         -     0%     0%  1.00x    ONLINE  -
pool   960M  6.07M   954M        -         -     0%     0%  1.00x    ONLINE  -
```

Получаем информацию
```
[root@server ~]# zpool get size otus
NAME  PROPERTY  VALUE  SOURCE
otus  size      480M   -
[root@server ~]# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  2.04M                  -
otus  available             350M                   -
otus  referenced            24K                    -
otus  compressratio         1.00x                  -
otus  mounted               no                     -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        2.01M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           1020K                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              off                    default
otus  redundant_metadata    all                    default
otus  overlay               off                    default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0                      default

```
Тип filesystem 

Размер 480M

recordsize 128K

сжатие zle

контрольная сумма sha256

# **Найти сообщение от преподавателей**

Восстанавливаем снапшот

```
zfs create pool/data
zfs receive pool/data/text2 < otus_task2.file
```
Смотрим секрет

```
cat /pool/data/text2/task1/file_mess/secret_message
```
Ответ: https://github.com/sindresorhus/awesome
