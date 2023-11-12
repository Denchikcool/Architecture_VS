#!/bin/bash
 
echo "����:"
date
echo
 
echo "��� ������� ������:"
whoami
echo
 
echo "�������� ��� ��:"
hostname
echo
 
echo "���������:"
echo "������ - $(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "����������� - $(uname -p)"
echo "�������� ������� ������������ - $(cat /proc/cpuinfo | grep "cpu MHz" | head -n 1 | cut -d ":" -f 2 | sed 's/^ *//g') MHz"
echo "�������� ������� ������� - $(sudo dmesg | grep "tsc: Detected" | cut -c 29-41 | sed 's/^ *//g')"
echo "���������� ���� - $(nproc)"
echo "���������� ������� �� ���� ���� - $(lscpu | grep "������� �� ����" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "�������� ���������� - $(top -bn 1 | awk '/Cpu/ {print $2 "%"}')"
echo
 
echo "����������� ������:"
echo "Cache L1 - $(lscpu | grep "L1d cache" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Cache L2 - $(lscpu | grep "L2 cache" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "Cache L3 - $(lscpu | grep "L3 cache" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "����� - $(cat /proc/meminfo | grep "MemTotal" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "�������� - $(cat /proc/meminfo | grep "MemAvailable" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo
 
echo "������� ����:"
df -h | grep "/$" | awk '{print "����� - " $2; print "�������� - " $4}'
echo "���������� �������� - $(lsblk | grep -c "-sda")"
echo "�� ������� ������� ����� ����� � ��������� ��������� �����:"
 
 
echo "�������� �������:"
echo $(df -h | grep "sda[2]" | awk '{print $1}' | cut -c 6-9)
echo "����� ����� ������:"
echo $(df -h | grep "sda[2]" | awk '{print $2}')
echo "��������� ��������� �����:"
echo $(df -h | grep "sda[2]" | awk '{print $4}')
echo
 
echo "�������� �������:"
echo $(df -h | grep "sda[3]" | awk '{print $1}' | cut -c 6-9)
echo "����� ����� ������:"
echo $(df -h | grep "sda[3]" | awk '{print $2}')
echo "��������� ��������� �����:"
echo $(df -h | grep "sda[3]" | awk '{print $4}')
echo
 
 
echo "����� �������������� ������������:"
let "sum = 0"
for unspace in $(sudo parted /dev/sda print free | grep '��������� �����' | awk '{print $3}' | cut -c 1-4);
do
 
	let "sum = $sum + $unspace"
done
echo $sum " KB"
echo
 
 
echo "SWAP ����� - $(cat /proc/meminfo | grep "SwapTotal" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo "SWAP �������� - $(cat /proc/meminfo | grep "SwapFree" | cut -d ":" -f 2 | sed 's/^ *//g')"
echo
 
echo "������� ����������:"
echo "���������� ������� ����������� - $(ls /sys/class/net | wc -w)"
echo "��� ������� �������� ����������: ���, MAC, IP, �������� �����, ������������ �������� ����������, ����������� �������� ����������:"
for interface in $(ls /sys/class/net); do
  if [[ $interface != "lo" ]]; then
    echo "���������: $interface"
    echo "MAC: $(cat /sys/class/net/$interface/address)"
    echo "IP: $(ip addr show $interface | awk '/inet / {print $2}')"
    echo "�������� �����: $(ethtool $interface | grep "Supported link modes" | cut -d ":" -f 2 | sed 's/^ *//g')"
    ethtool $interface | grep "                    " | cut -d ":" -f 2 | sed 's/^ *//g' | head -n2
    echo "������������ �������� ����������: $(sudo ethtool $interface | grep "Speed:" | awk '{print $2}')"
	echo "����������� �������� ����������: $(speedtest-cli | grep "Upload" | cut -d ":" -f 2 | sed 's/^ *//g')"
    echo
  fi
done