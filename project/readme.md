# **Введение**

Итоговый проект для курса "Администратор Linux"


## **Web**

Тестовый сайт доступен из хост-машины http://192.168.9.2
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