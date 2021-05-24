# **Введение**

Домашнее задание для урока "Загрузка системы"

# **Запуск**

```
vagrant up
```

Во время запуска нажимаем 'e' редактируем загрузачную запись
Удаляем записи console=..., и добавляем в конце rd.break, после чего Ctr + X
Загрузка остановится.

```
switch_root:/# mount -o remount,rw /sysroot
switch_root:/# chroot /sysroot
sh-4.4# passwd root
sh-4.4# touch /.autorelabel
sh-4.4# exit
switch_root:/# mount -o remount,ro /sysroot
switch_root:/# reboot
```

Успешно заходим с новым паролем


# **Установить систему с LVM, после чего переименовать VG**

Переименуем раздел
```
[root@lvm ~]# vgrename VolGroup00 Otus
 Volume group "VolGroup00" successfully renamed to "Otus"
```

Сменим настройку в файлах

```
[root@lvm ~]# sed -i -e "s/VolGroup00/Otus/g" /etc/fstab
[root@lvm ~]# sed -i -e "s/VolGroup00/Otus/g" /etc/default/grub
[root@lvm ~]# sed -i -e "s/VolGroup00/Otus/g" /boot/grub2/grub.cfg
```

Пересоздаем initrd
```
[root@lvm ~]# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```
Проверяем

```
[root@lvm ~] vgs
  VG   #PV #LV #SN Attr   VSize   VFree
  Otus   1   2   0 wz--n- <38.97g    0
```

# **Добавить модуль в initrd**

Создаем папку и готовим скрипты

```
[root@lvm ~] mkdir /usr/lib/dracut/modules.d/01test

[root@lvm ~] cat >> /usr/lib/dracut/modules.d/01test/module-setup.sh << EOF
#!/bin/bash

check() {
    return 0
}
depends() {
    return 0
}
install() {
    inst_hook cleanup 00 "${moddir}/test.sh"
}
EOF

[root@lvm ~] cat >> /usr/lib/dracut/modules.d/01test/test.sh << EOF
#!/bin/bash
exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'
Hello! You are in dracut module!
 ___________________
< I'm dracut module >

msgend
sleep 10
echo " continuing...."
EOF

chmod +x /usr/lib/dracut/modules.d/01test/module-setup.sh
chmod +x /usr/lib/dracut/modules.d/01test/test.sh
```

Собираем образ

```
[root@lvm ~] dracut -f -v
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-862.2.3.el7.x86_64.img' done ***
```

Перезагружаемся видим

```
< I'm dracut module >
```