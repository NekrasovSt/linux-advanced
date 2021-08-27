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
[  4] local 172.16.10.2 port 41400 connected to 172.16.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec   109 MBytes   183 Mbits/sec  427    319 KBytes
[  4]   5.00-10.00  sec   107 MBytes   180 Mbits/sec  241    328 KBytes
[  4]  10.00-15.00  sec   108 MBytes   181 Mbits/sec  362    245 KBytes
[  4]  15.00-20.01  sec   109 MBytes   182 Mbits/sec  151    312 KBytes
[  4]  20.01-25.00  sec   107 MBytes   180 Mbits/sec  395    237 KBytes
[  4]  25.00-30.00  sec   107 MBytes   180 Mbits/sec  209    102 KBytes
[  4]  30.00-35.01  sec   108 MBytes   181 Mbits/sec  225    241 KBytes
[  4]  35.01-40.01  sec   108 MBytes   180 Mbits/sec  130    203 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.01  sec   863 MBytes   181 Mbits/sec  2140             sender
[  4]   0.00-40.01  sec   862 MBytes   181 Mbits/sec                  receiver

iperf Done.

```