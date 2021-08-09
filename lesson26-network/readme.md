# **Введение**

Домашнее задание по теме "Архитектура сетей"


# **Теоритическая часть**

Для получения свойств сети используем утилиту ipcalc

## **Office 1**

### **test servers**
Network: 192.168.2.64/26
Broadcast: 192.168.2.127
HostMin: 192.168.2.65
HostMax: 192.168.2.126

### **dev**
Network: 192.168.2.0/26
Broadcast: 192.168.2.63
HostMin: 192.168.2.1
HostMax: 192.168.2.62

### **managers**
Network: 192.168.2.128/26
Broadcast: 192.168.2.191
HostMin: 192.168.2.129
HostMax: 192.168.2.190

### **office**
Network: 192.168.2.192/26
Broadcast: 192.168.2.255
HostMin: 192.168.2.193
HostMax: 192.168.2.254

## **Office 2**

### **office hardware**
Network: 192.168.1.192/26
Broadcast: 192.168.1.255
HostMin: 192.168.1.193
HostMax: 192.168.1.254

### **test servers**
Network: 192.168.1.128/26
Broadcast: 192.168.1.191
HostMin: 192.168.1.129
HostMax: 192.168.1.190

### **dev**
Network: 192.168.1.0/25
Broadcast: 192.168.1.127
HostMin: 192.168.1.1
HostMax: 192.168.1.126

## **Central**

### **mgt-net(wifi)**
Network: 192.168.0.64/26
Broadcast: 192.168.0.127
HostMin: 192.168.0.65
HostMax: 192.168.0.126

### **directors**
mgt-net(wifi)
Network: 192.168.0.0/28
Broadcast: 192.168.0.15
HostMin: 192.168.0.1
HostMax: 192.168.0.14

### **office hardware**
Network: 192.168.0.32/28
Broadcast: 192.168.0.47
HostMin: 192.168.0.33
HostMax: 192.168.0.46


# **Запуск**

```
vagrant up
ansible-playbook install.yml
```