# **Введение**

Домашнее задание по теме "Фильтрация трафика - firewalld, iptables"


## **Запуск**
```
vagrant up
ansible-playbook install.yml
```

## **Проверка knocking port**
```
vagrant ssh centralRouter
```
Пробуем подключится ssh

```
[root@centralRouter]# ssh vagrant@192.168.255.1
```
Нет подуключения.

```
[root@centralRouter]# /home/vagrant/knock.sh 192.168.255.1 8881 7777 9991
ssh vagrant@192.168.255.1
```
Подключение успешно.

## **Проброс портов**

На хост машине переходим по ссылке http://192.168.11.121:8080/
Видим страницу приветсвия.