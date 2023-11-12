#!/bin/bash
 
echo "Дата:"
date
echo
 
echo "Имя учетной записи:"
whoami
echo
 
echo "Доменное имя ПК:"
hostname
echo
 
echo "Процессор:"
echo "Модель - $(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Архитектура - $(uname -p)"
echo "Тактовая частота максимальная - $(cat /proc/cpuinfo | grep "cpu MHz" | head -n 1 | cut -d ":" -f 2 | sed 's/^ *//g') MHz"
echo "Тактовая частота текущая - $(sudo dmesg | grep "tsc: Detected" | cut -c 29-41 | sed 's/^ *//g')"
echo "Количество ядер - $(nproc)"
echo "Количество потоков на одно ядро - $(lscpu | grep "Потоков на ядро" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Загрузка процессора - $(top -bn 1 | awk '/Cpu/ {print $2 "%"}')"
echo
 
echo "Оперативная память:"
echo "Cache L1 - $(lscpu | grep "L1d cache" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Cache L2 - $(lscpu | grep "L2 cache" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Cache L3 - $(lscpu | grep "L3 cache" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Всего - $(cat /proc/meminfo | grep "MemTotal" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Доступно - $(cat /proc/meminfo | grep "MemAvailable" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo
 
echo "Жесткий диск:"
df -h | grep "/$" | awk '{print "Всего - " $2; print "Доступно - " $4}'
echo "Количество разделов - $(lsblk | grep -c "-sda")"
echo "По каждому разделу общий объем и доступное свободное место:"
 
 
echo "Название раздела:"
echo $(df -h | grep "sda[2]" | awk '{print $1}' | cut -c 6-9)
echo "Общий объем раздел:"
echo $(df -h | grep "sda[2]" | awk '{print $2}')
echo "Доступное свободное место:"
echo $(df -h | grep "sda[2]" | awk '{print $4}')
echo
 
echo "Название раздела:"
echo $(df -h | grep "sda[3]" | awk '{print $1}' | cut -c 6-9)
echo "Общий объем раздел:"
echo $(df -h | grep "sda[3]" | awk '{print $2}')
echo "Доступное свободное место:"
echo $(df -h | grep "sda[3]" | awk '{print $4}')
echo
 
 
echo "Объем неразмеченного пространства:"
let "sum = 0"
for unspace in $(sudo parted /dev/sda print free | grep 'Свободное место' | awk '{print $3}' | cut -c 1-4);
do
 
	let "sum = $sum + $unspace"
done
echo $sum " KB"
echo
 
 
echo "SWAP всего - $(cat /proc/meminfo | grep "SwapTotal" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "SWAP доступно - $(cat /proc/meminfo | grep "SwapFree" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo
 
echo "Сетевые интерфейсы:"
echo "Количество сетевых интерфейсов - $(ls /sys/class/net | wc -w)"
echo "Для каждого сетевого интерфейса: имя, MAC, IP, стандарт связи, максимальная скорость соединения, фактическая скорость соединения:"
for interface in $(ls /sys/class/net); do
  if [[ $interface != "lo" ]]; then
    echo "Интерфейс: $interface"
    echo "MAC: $(cat /sys/class/net/$interface/address)"
    echo "IP: $(ip addr show $interface | awk '/inet / {print $2}')"
    echo "Стандарт связи: $(ethtool $interface | grep "Supported link modes" | cut -d ":" -f 2 | sed 's/^ *//g')"
    ethtool $interface | grep "                    " | cut -d ":" -f 2 | sed 's/^ *//g' | head -n2
    echo "Максимальная скорость соединения: $(sudo ethtool $interface | grep "Speed:" | awk '{print $2}')"
	echo "Фактическая скорость соединения: $(speedtest-cli | grep "Upload" | cut -d ":" -f 2 | sed 's/^ *//g')"
    echo
  fi
done