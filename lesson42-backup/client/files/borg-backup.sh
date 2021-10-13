#!/bin/bash

LOCKFILE=/tmp/lockfile
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "already running"
    exit
fi

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

export BORG_RSH="ssh -i /root/.ssh/id_rsa"
export BORG_REPO=ssh://borg@192.168.10.10/var/backup/repo
export BORG_PASSPHRASE='P@ssw0rd'
LOG="/var/log/borg_backup.log"
[ -f "$LOG" ] || touch "$LOG"
exec &> >(tee -i "$LOG")
exec 2>&1
echo "Starting backup"
borg create --verbose --stats ::'{now:%Y-%m-%d_%H:%M:%S}' /etc

echo "Pruning repository"
borg prune --list --keep-daily 90 --keep-monthly 12

rm -f ${LOCKFILE}