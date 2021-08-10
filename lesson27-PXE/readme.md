# **Введение**

Домашнее задание по теме "DHCP,PXE"

# **Запуск**

Запуск нужно выполнять в два этапа, подготовка сервера.

```
vagrant up pxeserver
ansible-playbook install.yml
```
Внимание playbook выполняет загрузку образов из интернета, придется подождать!

Запускаем клиент

```
vagrant up pxeclient
```
Заходим в экран Virtualbox, выбираем первый пункт меню, смотрим загрузку ОС. 