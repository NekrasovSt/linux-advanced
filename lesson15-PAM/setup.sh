yum install -y epel-release
yum install -y pam_script

useradd dayoff
echo "otus"|sudo passwd --stdin dayoff
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd.service
groupadd admins
usermod -aG admins vagrant


sed -i "2i auth  required  pam_script.so"  /etc/pam.d/sshd
cat <<'EOT' > /etc/pam_script
#!/bin/bash
if [[ `id -nG $PAM_USER | grep -qw 'admins'` ]]
then
exit 0
fi
if [[ `date +%u` > 5 ]]
then
exit 1
fi
EOT
chmod +x /etc/pam_script
systemctl restart sshd