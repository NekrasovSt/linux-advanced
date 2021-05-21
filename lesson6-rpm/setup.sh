#!/bin/bash

# Установка зависимостей
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc

wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

wget https://www.openssl.org/source/latest.tar.gz
tar -xvf latest.tar.gz
mv openssl-1.1.1k /root/openssl-1.1.1a

yum-builddep -y /root/rpmbuild/SPECS/nginx.spec

wget https://gist.githubusercontent.com/lalbrekht/6c4a989758fccf903729fc55531d3a50/raw/8104e513dd9403a4d7b5f1393996b728f8733dd4/gistfile1.txt
cat /home/vagrant/gistfile1.txt > /root/rpmbuild/SPECS/nginx.spec

rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec

#Создание репозитория
mkdir -p /usr/share/nginx/html/repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
createrepo /usr/share/nginx/html/repo/

#Добавляем свой репозиторий в конфиг
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF