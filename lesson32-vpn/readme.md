# **Введение**

Домашнее задание по теме "Мосты, туннели и VPN"

## **Запуск**

```
vagrant up
```
## **Запуск виртуалки в режиме tun**

```
ansible-playbook install-tap.yml
```
Проверим, запустим на сервере.

```
iperf3 -s
```
На клиенте

```
[vagrant@client ~]$ iperf3 -c 172.16.10.1 -t 40 -i 5
Connecting to host 172.16.10.1, port 5201
[  4] local 172.16.10.2 port 38538 connected to 172.16.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec  23.8 MBytes  39.9 Mbits/sec   25    157 KBytes
[  4]   5.00-10.01  sec  23.2 MBytes  38.9 Mbits/sec    2    200 KBytes
[  4]  10.01-15.00  sec  22.7 MBytes  38.1 Mbits/sec   13    178 KBytes
[  4]  15.00-20.00  sec  22.7 MBytes  38.1 Mbits/sec   26    154 KBytes
[  4]  20.00-25.00  sec  22.7 MBytes  38.1 Mbits/sec   30    141 KBytes
[  4]  25.00-30.01  sec  22.8 MBytes  38.3 Mbits/sec    1    186 KBytes
[  4]  30.01-35.01  sec  23.0 MBytes  38.6 Mbits/sec   11    212 KBytes
[  4]  35.01-40.00  sec  22.9 MBytes  38.4 Mbits/sec   52    181 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec   184 MBytes  38.6 Mbits/sec  160             sender
[  4]   0.00-40.00  sec   183 MBytes  38.4 Mbits/sec                  receiver

iperf Done.

```

Меняем режим
```
ansible-playbook install-tap.yml
[vagrant@client ~]$ iperf3 -c 172.16.10.1 -t 40 -i 5
Connecting to host 172.16.10.1, port 5201
[  4] local 172.16.10.2 port 38544 connected to 172.16.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec  24.9 MBytes  41.7 Mbits/sec   45    205 KBytes
[  4]   5.00-10.01  sec  23.0 MBytes  38.6 Mbits/sec   14    169 KBytes
[  4]  10.01-15.00  sec  22.7 MBytes  38.1 Mbits/sec    5    144 KBytes
[  4]  15.00-20.01  sec  23.0 MBytes  38.5 Mbits/sec    5    131 KBytes
[  4]  20.01-25.00  sec  23.0 MBytes  38.6 Mbits/sec   13    181 KBytes
[  4]  25.00-30.00  sec  23.6 MBytes  39.6 Mbits/sec   23    202 KBytes
[  4]  30.00-35.00  sec  22.7 MBytes  38.1 Mbits/sec   10    177 KBytes
[  4]  35.00-40.00  sec  22.8 MBytes  38.2 Mbits/sec   29    168 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec   186 MBytes  38.9 Mbits/sec  144             sender
[  4]   0.00-40.00  sec   185 MBytes  38.7 Mbits/sec                  receiver

iperf Done.
```
Видим небольшой прирост скорости.

## **Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку.**

Запуск

```
ansible-playbook install-ras.yml
```

Проверим
```
[vagrant@client ~]$ iperf3 -c 172.16.10.1 -t 40 -i 5
Connecting to host 172.16.10.1, port 5201
[  4] local 172.16.10.6 port 58932 connected to 172.16.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec  26.3 MBytes  44.1 Mbits/sec   20    177 KBytes
[  4]   5.00-10.01  sec  25.3 MBytes  42.4 Mbits/sec   41    146 KBytes
[  4]  10.01-15.00  sec  25.4 MBytes  42.6 Mbits/sec    2    194 KBytes
[  4]  15.00-20.00  sec  24.8 MBytes  41.5 Mbits/sec    7    172 KBytes
[  4]  20.00-25.00  sec  24.9 MBytes  41.8 Mbits/sec   16    162 KBytes
[  4]  25.00-30.00  sec  25.4 MBytes  42.6 Mbits/sec    3    198 KBytes
[  4]  30.00-35.01  sec  24.7 MBytes  41.4 Mbits/sec    2    171 KBytes
[  4]  35.01-40.01  sec  25.3 MBytes  42.4 Mbits/sec   10    204 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.01  sec   202 MBytes  42.4 Mbits/sec  101             sender
[  4]   0.00-40.01  sec   201 MBytes  42.2 Mbits/sec                  receiver

iperf Done.

```
