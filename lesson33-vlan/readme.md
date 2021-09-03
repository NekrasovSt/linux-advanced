# **Введение**

Домашнее задание по теме "VLAN'ы. LACP"

## **Запуск**

```
vagrant up
ansible-playbook install.yml
```
## **Проверка VLAN**

Зайдем на клиенты и сервера и пропингуем.
```
[vagrant@testClient1 ~]$ ip --brief a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::5054:ff:fe4d:77d3/64
eth1             UP             192.168.2.3/24 fe80::a00:27ff:fe70:270f/64
eth1.10@eth1     UP             10.10.10.254/24 fe80::a00:27ff:fe70:270f/64
[vagrant@testClient1 ~]$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.335 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.417 ms
```

```
[vagrant@testServer1 ~]$ ip --brief a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::5054:ff:fe4d:77d3/64
eth1             UP             192.168.2.2/24 fe80::a00:27ff:fe94:a01/64
eth1.10@eth1     UP             10.10.10.1/24 fe80::a00:27ff:fe94:a01/64
[vagrant@testServer1 ~]$ ping 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.350 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.394 ms
```

```
[vagrant@testClient2 ~]$ ip --brief a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::5054:ff:fe4d:77d3/64
eth1             UP             192.168.2.5/24 fe80::a00:27ff:fe9d:6b7e/64
eth1.20@eth1     UP             10.10.10.254/24 fe80::a00:27ff:fe9d:6b7e/64
[vagrant@testClient2 ~]$ ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.702 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.369 ms
```

```
[vagrant@testServer2 ~]$ ip --brief a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::5054:ff:fe4d:77d3/64
eth1             UP             192.168.2.4/24 fe80::a00:27ff:fe75:3edf/64
eth1.20@eth1     UP             10.10.10.1/24 fe80::a00:27ff:fe75:3edf/64
[vagrant@testServer2 ~]$ ping 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.412 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.702 ms
```
## **Проверка бондов**

```
[vagrant@centralRouter ~]$  cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: None
Currently Active Slave: eth1
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: eth1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:9d:9a:2a
Slave queue ID: 0

Slave Interface: eth2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:f1:97:66
Slave queue ID: 0
```
```
[vagrant@inetRouter ~]$ cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup) (fail_over_mac active)
Primary Slave: None
Currently Active Slave: eth1
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: eth1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:56:8f:11
Slave queue ID: 0

Slave Interface: eth2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:64:c8:8d
Slave queue ID: 0
```
Видим что бонды настроены и работают на обоих машинах.
