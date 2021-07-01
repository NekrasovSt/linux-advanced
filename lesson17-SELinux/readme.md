# **Введение**

Домашнее задание для урока "SELinux - когда все запрещено"

# **Запустить nginx на нестандартном порту 3-мя разными способами**

Настроим nginx на порт 8888 /etc/nginx/nginx.conf, сервер не запускается.
Сдесь и далее используем утилиту 
```
[root@nginx vagrant]# audit2why < /var/log/audit/audit.log
type=AVC msg=audit(1624963890.860:793): avc:  denied  { name_bind } for  pid=24186 comm="nginx" src=88 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:kerberos_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.

type=AVC msg=audit(1624964983.533:70): avc:  denied  { name_bind } for  pid=869 comm="nginx" src=8888 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
        The boolean nis_enabled was set incorrectly.
        Description:
        Allow nis to enabled

        Allow access by executing:
        # setsebool -P nis_enabled 1
```

1. Переключатели setsebool;
Выполним предложенное 
```
setsebool -P nis_enabled 1
```
Сервер запустился.

2. Добавление нестандартного порта в имеющийся тип
```
semanage port -a -t http_port_t -p tcp 8888
```
Сервер запустился.

3. Формирование и установка модуля SELinux

Выполним 
```
audit2allow -M httpd_add --debug < /var/log/audit/audit.log
```
После чего
```
semodule -i httpd_add.pp
```

Сервер запустился

# **Обеспечить работоспособность приложения при включенном selinux**

Выполним операцию на клиенте
```
[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
update failed: SERVFAIL

```

Выполним 
```
[root@ns01 vagrant]# audit2why < /var/log/audit/audit.log
type=AVC msg=audit(1625144312.894:1982): avc:  denied  { create } for  pid=5005 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.

[root@ns01 vagrant]# audit2allow -M named-selinux --debug < /var/log/audit/audit.log
[root@ns01 vagrant]# semodule -i named-selinux.pp
```
Этого не достаточно, проверим лог

```
cat /var/log/messages | grep SELinux

[root@ns01 vagrant]# cat /var/log/messages | grep SELinux
Jul  1 12:58:37 localhost python: SELinux is preventing isc-worker0000 from create access on the file named.ddns.lab.view1.jnl.#012#012*****  Plugin catchall_labels (83.8 confidence) suggests   *******************#012#012If you want to allow isc-worker0000 to have create access on the named.ddns.lab.view1.jnl file#012Then you need to change the label on named.ddns.lab.view1.jnl#012Do#012# semanage fcontext -a -t FILE_TYPE 'named.ddns.lab.view1.jnl'#012where FILE_TYPE is one of the following: dnssec_trigger_var_run_t, ipa_var_lib_t, krb5_host_rcache_t, krb5_keytab_t, named_cache_t, named_log_t, named_tmp_t, named_var_run_t, named_zone_t.#012Then execute:#012restorecon -v 'named.ddns.lab.view1.jnl'#012#012#012*****  Plugin catchall (17.1 confidence) suggests   **************************#012#012If you believe that isc-worker0000 should be allowed create access on the named.ddns.lab.view1.jnl file by default.#012Then you should report this as a bug.#012You can generate a local policy module to allow this access.#012Do#012allow this access for now by executing:#012# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000#012# semodule -i my-iscworker0000.pp#012
```

Выполним предложенное

```
[root@ns01 vagrant]# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000 | semodule -i my-iscworker0000.pp
```

Перезапускаем сервис

```
[root@ns01 vagrant]# systemctl restart named
[root@ns01 vagrant]# systemctl status named
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-07-01 13:08:54 UTC; 1s ago
  Process: 5179 ExecStop=/bin/sh -c /usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID (code=exited, status=0/SUCCESS)
  Process: 5192 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (code=exited, status=0/SUCCESS)
  Process: 5190 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi (code=exited, status=0/SUCCESS)
 Main PID: 5194 (named)
   CGroup: /system.slice/named.service
           └─5194 /usr/sbin/named -u named -c /etc/named.conf
```

Проверяем с клиента, операция выполнена.

# **Вывод**

Проблема в том что named.service не мог получить доступ к /etc/named/dynamic/named.ddns.lab.view1.jnl

