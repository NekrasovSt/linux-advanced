# **Введение**

Домашнее задание по теме "DNS- настройка и обслуживание"

## **Запуск**

```
vagrant up
ansible-playbook install.yml
```

## **Проверка**

### **Client1**

```
[vagrant@client1 ~]$ dig web1.dns.lab +short @ns01.dns.lab
192.168.50.15
[vagrant@client1 ~]$ dig web1.dns.lab +short @ns02.dns.lab
192.168.50.15
[vagrant@client1 ~]$ dig web2.dns.lab +short @ns01.dns.lab
[vagrant@client1 ~]$ dig web2.dns.lab +short @ns02.dns.lab
[vagrant@client1 ~]$ dig www.newdns.lab  +short @ns01.dns.lab
192.168.50.103
[vagrant@client1 ~]$ dig www.newdns.lab  +short @ns02.dns.lab
192.168.50.103
```

web1.dns.lab и www.newdns.lab доступны, web2.dns.lab нет.

### **Client2**
```
[vagrant@client2 ~]$ dig web1.dns.lab +short @ns02.dns.lab
192.168.50.15
[vagrant@client2 ~]$ dig web2.dns.lab +short @ns01.dns.lab
192.168.50.16
[vagrant@client2 ~]$ dig web2.dns.lab +short @ns02.dns.lab
192.168.50.16
[vagrant@client2 ~]$ dig www.newdns.lab +short @ns01.dns.lab
[vagrant@client2 ~]$ dig www.newdns.lab +short @ns02.dns.lab
```
web1.dns.lab и web2.dns.lab доступны, www.newdns.lab нет.
