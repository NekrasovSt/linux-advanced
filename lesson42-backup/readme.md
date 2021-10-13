# **Введение**

Домашнее задание по теме "PostgreSQl"

## **Запуск**

```
vagrant up
ansible-playbook install.yml
```
## **Проверка**

Проверим статус юнита для бэкапа

```
[root@client vagrant]# systemctl status borg-backup.service
● borg-backup.service - Borg /etc backup
   Loaded: loaded (/etc/systemd/system/borg-backup.service; static; vendor preset: disabled)
   Active: inactive (dead) since Wed 2021-10-13 16:11:10 UTC; 1min 42s ago
  Process: 4471 ExecStart=/root/borg-backup.sh (code=exited, status=0/SUCCESS)
 Main PID: 4471 (code=exited, status=0/SUCCESS)

Oct 13 16:11:09 client borg-backup.sh[4471]: Original size      Compressed size    Deduplicated size
Oct 13 16:11:09 client borg-backup.sh[4471]: This archive:               28.43 MB             13.49 MB             11.84 MB
Oct 13 16:11:09 client borg-backup.sh[4471]: All archives:               28.43 MB             13.49 MB             11.84 MB
Oct 13 16:11:09 client borg-backup.sh[4471]: Unique chunks         Total chunks
Oct 13 16:11:09 client borg-backup.sh[4471]: Chunk index:                    1277                 1693
Oct 13 16:11:09 client borg-backup.sh[4471]: ------------------------------------------------------------------------------
Oct 13 16:11:09 client borg-backup.sh[4471]: Pruning repository
Oct 13 16:11:09 client borg-backup.sh[4471]: Remote: Warning: Permanently added '192.168.10.10' (ECDSA) to the list of known hosts.
Oct 13 16:11:10 client borg-backup.sh[4471]: Keeping archive: 2021-10-13_16:11:05                  Wed, 2021-10-13 16:11:06 [c0616fcd0f290af43a3432922ae82af84495b97fbca2f7d847b5da8195b23469]
Oct 13 16:11:10 client systemd[1]: Started Borg /etc backup.
```

Проверим бэкапы

```
[root@client vagrant]# borg list ssh://borg@192.168.10.10/var/backup/repo
Remote: Warning: Permanently added '192.168.10.10' (ECDSA) to the list of known hosts.
Enter passphrase for key ssh://borg@192.168.10.10/var/backup/repo:
2021-10-13_16:11:05                  Wed, 2021-10-13 16:11:06 [c0616fcd0f290af43a3432922ae82af84495b97fbca2f7d847b5da8195b23469]
```

Скачаем бэкап

```
[root@client vagrant]# borg extract ssh://borg@192.168.10.10/var/backup/repo::2021-10-13_16:11:05
[root@client vagrant]# ls
etc
```
Папка etc есть и содержит настройки.