#!/bin/bash

# Проверяем, передан ли параметр
if [ $# -gt 0 ]; then
  echo "Ошибка: Параметры не требуются."
  exit 1
fi

# Получение системной информации
HOSTNAME=$(hostname)
TIMEZONE=$(date +"%Z UTC-%u")
USER=$(whoami)
OS=$(cat /etc/os-release | grep -E "PRETTY_NAME" | awk -F '"' '{print $2}')
DATE=$(date +"%d %B %Y %T")
UPTIME=$(uptime -p)
UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
PREFIX=$(ip -4 addr show | awk '/inet / {split($2, a, "/"); print a[2]}' | head -n 1)
MASK=$(bash mask_calc.sh $PREFIX)
GATEWAY=$(ip route | grep 'default via' | awk '{print $4}')
RAM_TOTAL=$(free | grep 'Mem' | awk '{ printf "%.3f GB\n", $2/1048576 }')
RAM_USED=$(free | grep 'Mem' | awk '{ printf "%.3f GB\n", $3/1048576 }')
RAM_FREE=$(free | grep 'Mem' | awk '{ printf "%.3f GB\n", $4/1048576 }')
SPACE_ROOT=$(df / | awk '/\// {printf "%.2f MB\n", substr($2, 1, $2)/1024}')
SPACE_ROOT_USED=$(df  / | awk '/\// {printf "%.2f MB\n", substr($3, 1,$3)/1024}')
SPACE_ROOT_FREE=$(df  / | awk '/\// {printf "%.2f MB\n", substr($4, 1, $4)/1024}')


# Вывод информации на экран
echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $TIMEZONE"
echo "USER = $USER"
echo "OS = $OS"
echo "DATE = $DATE"
echo "UPTIME = $UPTIME"
echo "UPTIME_SEC = $UPTIME_SEC"
echo "IP = $IP"
echo "MASK = $MASK"
echo "GATEWAY = $GATEWAY"
echo "RAM_TOTAL = $RAM_TOTAL"
echo "RAM_USED = $RAM_USED"
echo "RAM_FREE = $RAM_FREE"
echo "SPACE_ROOT = $SPACE_ROOT"
echo "SPACE_ROOT_USED = $SPACE_ROOT_USED"
echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE"

# Запрос на сохранение в файл
read -p "Желаете сохранить информацию в файл (Y/N)? " choice
if [[ $choice == [Yy] ]]; then
  # Формирование имени файла
  filename=$(date +"%d_%m_%y_%H_%M_%S.status")
  # Запись информации в файл
  echo -e "HOSTNAME = $HOSTNAME\nTIMEZONE = $TIMEZONE\nUSER = $USER\nOS = $OS\nDATE = $DATE\nUPTIME = $UPTIME\nUPTIME_SEC = $UPTIME_SEC\nIP = $IP\nMASK = $MASK\nGATEWAY = $GATEWAY\nRAM_TOTAL = $RAM_TOTAL\nRAM_USED = $RAM_USED\nRAM_FREE = $RAM_FREE\nSPACE_ROOT = $SPACE_ROOT\nSPACE_ROOT_USED = $SPACE_ROOT_USED\nSPACE_ROOT_FREE = $SPACE_ROOT_FREE" > "$filename"
  echo "Информация сохранена в файл $filename"
else
  echo "Информация не сохранена в файл."
fi