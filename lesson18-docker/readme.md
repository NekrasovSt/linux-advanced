# **Введение**

Домашнее задание для урока "docker"

На база alpine собран образ с кастомной страницей, Dockerfile приложен


Запуск 

```
docker run -d -p 80:80 --name nginx-test pitchcontrol/nginx-test:latest
```

Проверка запустить браузер http://localhost