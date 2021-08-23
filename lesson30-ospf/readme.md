# **Введение**

Домашнее задание по теме "Статическая и динамическая маршрутизация, OSPF"


## **Запуск**
```
vagrant up
ansible-playbook install.yml
```

## **OSPF между машинами на базе Quagga**

Заходим на машины r1,r2,r3 и проверяем что маршруты построены.

Например для r1
```
[root@r1 ~]# ip route
default via 10.0.2.2 dev eth0 proto dhcp metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100
172.16.1.0/24 dev eth1 proto kernel scope link src 172.16.1.1 metric 101
172.16.2.0/24 dev eth2 proto kernel scope link src 172.16.2.1 metric 102
172.16.3.0/24 proto zebra metric 20
        nexthop via 172.16.1.2 dev eth1 weight 1
        nexthop via 172.16.2.3 dev eth2 weight 1
```
Либо воспользоватся утилитой vtysh.

## **Изобразить ассиметричный роутинг**

Для этого увеличим стоимость пути link1

На роутере r2
```
[root@r2 ~]# vtysh
r2# configure  terminal
r2(config)# interface  eth2
r2(config-if)# ip ospf  cost  1000
r2(config-if)# ^Z
r2# ^Z
r2# exit
```

Смотрим на r1

```
[root@r1 ~]# traceroute 172.16.3.2
traceroute to 172.16.3.2 (172.16.3.2), 30 hops max, 60 byte packets
 1  172.16.2.3 (172.16.2.3)  0.940 ms  0.706 ms  0.714 ms
 2  172.16.3.2 (172.16.3.2)  1.204 ms  1.625 ms  1.221 ms
```
Трафик пошел в обход.

## **Сделать один из линков "дорогим", но чтобы при этом роутинг был симметричным**

Делаем стоимость на r2 для второго интерфейса 1000.

```
traceroute to 172.16.3.2 (172.16.3.2), 30 hops max, 60 byte packets
 1  172.16.3.2 (172.16.3.2)  0.514 ms  0.285 ms  0.340 ms
```
Трафик снова пошел напрямую.