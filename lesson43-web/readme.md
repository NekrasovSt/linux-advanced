# **Введение**

Домашнее задание по теме "Динамический веб"

## **Запуск**

```
vagrant up
```

## **Проверка**

Hello world на Go
http://192.168.10.10:81/

Тестовое приложение .Net Core + Vue, упакованно в докер. Репо https://github.com/NekrasovSt/Agency, использует Postgres
http://192.168.10.10:81/

Hello world на Django
http://192.168.10.10:83/


PS Запускаю на Windows + WSL по этому vagrant provision ansible не могу проверить. 
Если не заработает тогда закоментировать строку
```
w.vm.provision "ansible" do |ansible|
    ansible.playbook = "install.yml"
end
```
и запустить
```
vagrant up
ansible-playbook install.yml
```
