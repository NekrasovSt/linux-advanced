# **Введение**

Домашнее задание по теме "PostgreSQl"

## **Запуск**

```
vagrant up
ansible-playbook install.yml
```
## **Проверка**
### **Master**

Проверим наличие баз и пользователей
```
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)

postgres=# \du
                                         List of roles
       Role name       |                         Attributes                         | Member of
-----------------------+------------------------------------------------------------+-----------
 barman                | Superuser                                                  | {}
 barman_streaming_user | Replication                                                | {}
 postgres              | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 streaming_user        | Replication                                                | {}

```

Добавим БД

```
postgres=# CREATE DATABASE Tmp;
CREATE DATABASE
```
### **Slave**

Проверим наличие базы tmp.
```
psql (11.13)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 tmp       | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
(4 rows)

```

### **Backup**

Проверим стату подключения barman
```
[root@backup vagrant]# barman check master
Server master:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        archiver errors: OK
[root@backup vagrant]# barman status master
Server master:
        Description: PostgreSQL Backup
        Active: True
        Disabled: False
        PostgreSQL version: 11.13
        Cluster state: in production
        pgespresso extension: Not available
        Current data size: 30.2 MiB
        PostgreSQL Data directory: /var/lib/pgsql/11/data
        Current WAL segment: 00000001000000000000000F
        PostgreSQL 'archive_command' setting: barman-wal-archive backup master %p
        Last archived WAL: No WAL segment shipped yet
        Failures of WAL archiver: 228 (000000010000000000000001 at Tue Oct  5 05:30:50 2021)
        Passive node: False
        Retention policies: not enforced
        No. of available backups: 0
        First available backup: None
        Last available backup: None
        Minimum redundancy requirements: satisfied (0/0)

```