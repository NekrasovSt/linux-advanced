# **Введение**

Домашнее задание по теме "LDAP"

## **Запуск**

```
vagrant up
ansible-playbook install.yml
```

## **Проверка**

Логинимся в LDAP
```
[root@ipaserver vagrant]# kinit admin
Password for admin@MYTEST.LAB:
[root@ipaserver vagrant]# klist
Ticket cache: KEYRING:persistent:0:0
Default principal: admin@MYTEST.LAB

Valid starting       Expires              Service principal
09/08/2021 22:33:30  09/09/2021 22:33:25  krbtgt/MYTEST.LAB@MYTEST.LAB

```

Проверим что пользователь добавлен
```
[root@ipaserver vagrant]# ipa user-find stas
--------------
1 user matched
--------------
  User login: stas
  First name: Stanislav
  Last name: Nekrasov
  Home directory: /home/stas
  Login shell: /bin/bash
  Principal name: stas@MYTEST.LAB
  Principal alias: stas@MYTEST.LAB
  Email address: stas@mytest.lab
  UID: 1531800001
  GID: 1531800001
  SSH public key fingerprint: SHA256:zs4Z3HYhqRtZsbI8xASbx0pkb12338kUGuib7kE82Jc stas@mytest.lab (ssh-rsa)
  Account disabled: False
----------------------------
Number of entries returned 1
----------------------------
```

Пробуем зайти на другие машины.

Первый вход пароль stas123456
```
[root@ws1 vagrant]# ssh stas@ws2.mytest.lab
Password:
Password expired. Change your password now.
Current Password:
New password:
Retype new password:
Creating home directory for stas.
[stas@ws2 ~]$ exit
logout
Connection to ws2.mytest.lab closed.
[root@ws1 vagrant]# ssh stas@ipaserver.mytest.lab
Password:
Creating home directory for stas.
```

Получается войти из ws1 на ws2 и ipaserver, можно также попробовать с других хостов.