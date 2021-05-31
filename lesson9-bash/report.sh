#!/bin/bash
# flock -w0 /tmp/1.lock /1.sh  https://ru.stackoverflow.com/questions/993265/%D0%97%D0%B0%D0%BF%D1%80%D0%B5%D1%82%D0%B8%D1%82%D1%8C-%D0%BE%D0%B4%D0%BD%D0%BE%D0%B2%D1%80%D0%B5%D0%BC%D0%B5%D0%BD%D0%BD%D0%BE%D0%B5-%D0%B2%D1%8B%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-bash-%D1%81%D0%BA%D1%80%D0%B8%D0%BF%D1%82%D0%B0
set -o errexit
set -o nounset
set -o pipefail

main(){
    local limit=10
    local lastoperation_file="lastoperation.txt"
    local templog="temp.log"
    if ! [[  -f $lastoperation_file ]];
    then
        head -1 $1 | awk '{print $4 }' | cut -c 2- > $lastoperation_file;
    fi
    local last_operation_date=$(cat $lastoperation_file)
    local line_number=$(cat -n $1 | grep "$last_operation_date" | awk '{print $1}')

    echo $line_number
    cat $1 | sed -n "${line_number},\$p" > $templog

    # Записывае время последнего лога
    cat $1 | tail -n 1 | awk '{print $4 }' | cut -c 2- > $lastoperation_file

    # Вывод отчета
    echo "" > report.txt

    echo "$limit IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта" >> report.txt
    cat $templog | awk '{print $1}' | sort | uniq -c | sort -rn -k1 | head -n $limit >> report.txt

    echo "$limit запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта" >> report.txt
    cat $templog | awk '{print $7}' | sort | uniq -c | sort -rn -k1 | head -n $limit >> report.txt

    echo "все ошибки c момента последнего запуска" >> report.txt
    cat $templog | awk '($9 ~ /[45]../){print $9}' | sort | uniq -c | sort -rn -k1 >> report.txt

    echo "список всех кодов возврата с указанием их кол-ва с момента последнего запуска скрипта" >> report.txt
    cat $templog | awk '{print $9}'| grep -v "-" | sort | uniq -c | sort -rn -k1 >> report.txt

    # Очистка временного файла
    rm -f $templog
}

lockfile=/tmp/localfile
if ( set -o noclobber; echo "$$">"$lockfile" ) 2>/dev/null; then
    trap "rm -f "$lockfile";exit $?" INT TERM EXIT
    main $1
    rm -f $lockfile
    trap - INT TERM EXIT
else
    echo "Уже выполняется"
fi