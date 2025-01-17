# **Введение**

Итоговый проект для курса "Администратор Linux"

![](screenshots/schema.png)

## **Запуск**

```
vagrant up
ansible-playbook install.yml
```
## **Firewall**

Настроен проброс портов для машин в DMZ

```
[root@firewall vagrant]# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0 eth2
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  masquerade: yes
  forward-ports:
        port=80:proto=tcp:toport=80:toaddr=192.168.10.5
        port=443:proto=tcp:toport=443:toaddr=192.168.10.5
        port=10001:proto=tcp:toport=10001:toaddr=192.168.10.5
        port=7000:proto=tcp:toport=7000:toaddr=192.168.10.8
        port=9090:proto=tcp:toport=9090:toaddr=192.168.10.5
        port=3000:proto=tcp:toport=3000:toaddr=192.168.10.5
  source-ports:
  icmp-blocks:
  rich rules:
```

## **Web**

Тестовый сайт доступен из хост-машины http://192.168.9.2, настроен редирект на https.
Веб состоит из 3х машин:
* webserver1,webserver1 - Докер контейнер с запущеным проектом https://github.com/NekrasovSt/Agency, запросы проксирует nginx
* webproxy - HAProxy который балансирует нагрузку.

Веб интерфейс балансировки http://192.168.9.2:10001/

## **База данных**

Инфраструктура базы данных построена на основе Postgresql
* db1, db1 - Patroni, Postgresql
* dbproxy - HAProxy который балансирует нагрузку.

Веб интерфейс балансировки http://192.168.9.2:7000/

На все трех машинах установлен etcd в едином кластере.

Проверить статус кластера etcd
```
[root@db1 ~]# etcdctl cluster-health
member 1bba04e768f664ce is healthy: got healthy result from http://192.168.10.8:2379
member 315fd62e577c4037 is healthy: got healthy result from http://192.168.10.7:2379
member f617da66fb9b90ad is healthy: got healthy result from http://192.168.10.6:2379
cluster is healthy

[root@db1 ~]# etcdctl member list
1bba04e768f664ce: name=dbproxy peerURLs=http://192.168.10.8:2380 clientURLs=http://192.168.10.8:2379 isLeader=false
315fd62e577c4037: name=db2 peerURLs=http://192.168.10.7:2380 clientURLs=http://192.168.10.7:2379 isLeader=false
f617da66fb9b90ad: name=db1 peerURLs=http://192.168.10.6:2380 clientURLs=http://192.168.10.6:2379 isLeader=true

```
Проверить статус кластера patroni
```
[root@db1 ~]# patronictl -c /opt/app/patroni/etc/postgresql.yml list
+ Cluster: postgres (7030135220880711238) --+----+-----------+
| Member |     Host     |  Role  |  State   | TL | Lag in MB |
+--------+--------------+--------+----------+----+-----------+
|  db1   | 192.168.10.6 | Leader | running  |  3 |           |
|  db2   | 192.168.10.7 |        | starting |    |   unknown |
+--------+--------------+--------+----------+----+-----------+

```
пример switchover

```
Master [db2]: db2
Candidate ['db1'] []: db1
When should the switchover take place (e.g. 2021-11-28T13:52 )  [now]: now
Current cluster topology
+ Cluster: postgres (7034168596599710655) -+----+-----------+
| Member |     Host     |  Role  |  State  | TL | Lag in MB |
+--------+--------------+--------+---------+----+-----------+
|  db1   | 192.168.10.6 |        | running |  6 |         0 |
|  db2   | 192.168.10.7 | Leader | running |  6 |           |
+--------+--------------+--------+---------+----+-----------+
Are you sure you want to switchover cluster postgres, demoting current master db2? [y/N]: y
2021-11-28 12:52:46.47195 Successfully switched over to "db1"

```

Проверим базу данных
```
[root@webserver1 ~]# psql -U admin -h 192.168.10.8 -p 5000 -d Agency
Password for user admin:
psql (10.17)
Type "help" for help.

Agency=> \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 Agency    | admin    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

```
Доступных пользователей
```
[root@db1 vagrant]# psql -U admin -h 192.168.10.8 -p 5000 -d Agency
Password for user admin:
psql (10.17)
Type "help" for help.

Agency=> \du
                                    List of roles
 Role name  |                         Attributes                         | Member of
------------+------------------------------------------------------------+-----------
 admin      | Create role, Create DB                                     | {}
 postgres   | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 replicator | Replication                                                | {}

```
### **backup & restore**
Попробуем выполнить восстановление из бэкапа в ручном режиме
На слэйв ноде сделаем резервную копию
```
[root@db1 vagrant]# mkdir -p /var/backup
[root@db1 vagrant]# pg_basebackup --pgdata=/var/backup --format=tar --gzip --compress=9 --label=base_backup  --username=replicator --progress --verbose
[root@db1 vagrant]# ll /var/backup/
total 3544
-rw-r--r--. 1 root root 3606002 Nov 28 14:15 base.tar.gz
-rw-------. 1 root root   18864 Nov 28 14:15 pg_wal.tar.gz
```

Дропнем базу
```
psql -U admin -h 192.168.10.8 -p 5000 -d postgres
postgres=> drop database "Agency";
DROP DATABASE
postgres=> \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)

postgres=>
```
Останавливаем patroni на обоих нодах
```
[root@db1 vagrant]# systemctl stop patroni
```
Удалим файлы баз данных на обоих нодах

```
[root@db1 vagrant]# rm -rf /var/lib/pgsql/data/*
```
Удаляем кластер
```
[root@db1 vagrant]# patronictl -c /opt/app/patroni/etc/postgresql.yml remove postgres
+ Cluster: postgres (7034168596599710655) ------+
| Member | Host | Role | State | TL | Lag in MB |
+--------+------+------+-------+----+-----------+
+--------+------+------+-------+----+-----------+
Please confirm the cluster name to remove: postgres
You are about to remove all information in DCS for postgres, please type: "Yes I am aware": Yes I am aware
```
Копируем файлы бэкапа
```
[root@db1 vagrant]# tar xzfp /var/backup/base.tar.gz -C /var/lib/pgsql/data/
[root@db1 vagrant]# tar xzfp /var/backup/pg_wal.tar.gz -C /var/lib/pgsql/data/pg_wal/
```
Стартуем на обоих нодах
```
[root@db1 vagrant]# systemctl start patroni

[root@db2 vagrant]# systemctl start patroni
[root@db1 vagrant]# patronictl -c /opt/app/patroni/etc/postgresql.yml list
+ Cluster: postgres (7034168596599710655) -+----+-----------+
| Member |     Host     |  Role  |  State  | TL | Lag in MB |
+--------+--------------+--------+---------+----+-----------+
|  db1   | 192.168.10.6 | Leader | running | 10 |           |
|  db2   | 192.168.10.7 |        | running | 10 |         0 |
+--------+--------------+--------+---------+----+-----------+
```
Данные восcтановлены!

### **etcd**
Список ключей
```
[vagrant@db1 ~]$ etcdctl ls / --recursive
/pg_cluster
/pg_cluster/postgres
/pg_cluster/postgres/members
/pg_cluster/postgres/members/db2
/pg_cluster/postgres/members/db1
/pg_cluster/postgres/initialize
/pg_cluster/postgres/config
/pg_cluster/postgres/leader
/pg_cluster/postgres/optime
/pg_cluster/postgres/optime/leader
```
Узнать кто лидер
```
[vagrant@db1 ~]$ etcdctl get /pg_cluster/postgres/leader
db2
```

## **Логирование**

Для логирование используется systemd-journal-remote
Логи собираются со всех машин кроме logserver

```
[root@logserver ~]# ls /var/log/journal/remote
remote-192.168.10.1.journal  remote-192.168.10.2.journal  remote-192.168.10.3.journal  remote-192.168.10.5.journal  remote-192.168.10.6.journal  remote-192.168.10.7.journal  remote-192.168.10.8.journal
```
Просмотр всех сразу
```
[root@logserver ~]# journalctl -D /var/log/journal/remote --follow
-- Logs begin at Mon 2021-11-15 14:12:07 UTC. --
Nov 15 15:10:22 webserver1 systemd[1]: Removed slice User Slice of UID 1000.
Nov 15 15:10:22 webserver1 systemd[1]: run-user-1000.mount: Succeeded.
Nov 15 15:10:22 webserver1 systemd[1]: user-runtime-dir@1000.service: Succeeded.
Nov 15 15:10:22 webserver1 systemd[1]: Stopped /run/user/1000 mount wrapper.
Nov 15 15:10:30 firewall sshd[8045]: Received disconnect from 10.0.2.2 port 52332:11: disconnected by user
Nov 15 15:10:30 firewall sshd[8045]: Disconnected from user vagrant 10.0.2.2 port 52332
Nov 15 15:10:30 firewall sshd[8042]: pam_unix(sshd:session): session closed for user vagrant
Nov 15 15:10:30 firewall systemd[1]: session-8.scope: Succeeded.
Nov 15 15:10:30 firewall systemd-logind[683]: Session 8 logged out. Waiting for processes to exit.
Nov 15 15:10:30 firewall systemd-logind[683]: Removed session 8.
```
Либо по определенной машине
```
[root@logserver ~]# journalctl --file=/var/log/journal/remote/remote-192.168.10.5.journal --follow
-- Logs begin at Mon 2021-11-15 14:14:01 UTC. --
Nov 15 15:10:23 webproxy systemd-logind[711]: Removed session 19.
Nov 15 15:18:01 webproxy anacron[9336]: Job `cron.daily' started
Nov 15 15:18:01 webproxy run-parts[11026]: (/etc/cron.daily) starting logrotate
Nov 15 15:18:01 webproxy run-parts[11031]: (/etc/cron.daily) finished logrotate
Nov 15 15:18:01 webproxy anacron[9336]: Job `cron.daily' terminated
Nov 15 15:18:01 webproxy anacron[9336]: Normal exit (1 job run)
Nov 15 15:25:50 webproxy systemd[1]: Starting dnf makecache...
Nov 15 15:25:50 webproxy dnf[11034]: Metadata cache refreshed recently.
Nov 15 15:25:50 webproxy systemd[1]: dnf-makecache.service: Succeeded.
Nov 15 15:25:50 webproxy systemd[1]: Started dnf makecache.
```
## **Мониторинг**

Мониторинг осуществляется при помощи Prometheus, node_exporter, Grafana
На вссех машинах установлен node_exporter.
На webproxy Prometheus + Grafana
Prometheus: http://192.168.9.2:9090/
Grafana: http://192.168.9.2:3000/ Доступ admin/admin
![](screenshots/grafana.png)
## **Алертинг**

Для примера настроен алерт недоступна машина более 1 мин.

Для примера можно выключить любую и посмотреть.
http://192.168.9.2:9090/alerts
![](screenshots/alert.png)