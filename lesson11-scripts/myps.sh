#!/usr/bin/env bash

echo "PID |TTY |STAT |TIME |COMMAND "

for pid in $(ls -l /proc | awk '{print $9}' | grep -E "^[0-9]+" | sort -n );
do

tty=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $7}')
stat=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $3}')
time=$(cat 2>/dev/null /proc/$pid/stat | awk '{print ($14+$17)/60}')
cmd=$(cat 2>/dev/null /proc/$pid/cmdline | awk '{print $0}')

printf "%-8s %-8s %-1s %-s %-50s\n" $pid $tty $stat $time $cmd
done