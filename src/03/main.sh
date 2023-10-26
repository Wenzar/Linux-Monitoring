#!/bin/bash

# Проверка количества переданных параметров
if [ $# -ne 4 ]; then
  echo "Ошибка: Необходимо передать ровно 4 параметра."
  exit 1
fi

# Проверка допустимых значений параметров
valid_colors=(1 2 3 4 5 6)
if ! [[ " ${valid_colors[*]} " =~ " $1 " ]] || ! [[ " ${valid_colors[*]} " =~ " $2 " ]] || \
   ! [[ " ${valid_colors[*]} " =~ " $3 " ]] || ! [[ " ${valid_colors[*]} " =~ " $4 " ]]; then
  echo "Ошибка: Недопустимые значения параметров. Параметры должны быть числами от 1 до 6."
  exit 1
fi

# Проверка, что цвета шрифта и фона не совпадают
if [ "$1" -eq "$2" ] || [ "$3" -eq "$4" ]; then
  echo "Ошибка: Цвета шрифта и фона должны различаться. Попробуйте еще раз!"
  exit 1
fi

# Функция для вывода информации с заданными цветами
print_colored_info() {
  local bg_name=("White" "Red" "Green" "Blue" "Purple" "Black")
  local fg_name=("White" "Red" "Green" "Blue" "Purple" "Black")
  local bg_color=("47" "41" "42" "44" "45" "40")
  local fg_color=("37" "31" "32" "34" "35" "30")

  local bg1="${bg_color[$1-1]}"
  local fg1="${fg_color[$2-1]}"
  local bg2="${bg_color[$3-1]}"
  local fg2="${fg_color[$4-1]}"
  PREFIX=$(ip -4 addr show | awk '/inet / {split($2, a, "/"); print a[2]}' | head -n 1)

# use ANSI escape codes

  echo -e "\033[${bg1};${fg1}mHOSTNAME\033[0m = \033[${bg2};${fg2}m$(hostname)\033[0m"
  echo -e "\033[${bg1};${fg1}mTIMEZONE\033[0m = \033[${bg2};${fg2}m$(date +"%Z UTC-%u")\033[0m"
  echo -e "\033[${bg1};${fg1}mUSER\033[0m = \033[${bg2};${fg2}m$(whoami)\033[0m"
  echo -e "\033[${bg1};${fg1}mOS\033[0m = \033[${bg2};${fg2}m$(cat /etc/os-release | grep -E 'PRETTY_NAME' | awk -F '"' '{print $2}')\033[0m"
  echo -e "\033[${bg1};${fg1}mDATE\033[0m = \033[${bg2};${fg2}m$(date +'%d %B %Y %T')\033[0m"
  echo -e "\033[${bg1};${fg1}mUPTIME\033[0m = \033[${bg2};${fg2}m$(uptime -p)\033[0m"
  echo -e "\033[${bg1};${fg1}mUPTIME_SEC\033[0m = \033[${bg2};${fg2}m$(awk '{print int($1)}' /proc/uptime)\033[0m"
  echo -e "\033[${bg1};${fg1}mIP\033[0m = \033[${bg2};${fg2}m$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)\033[0m"
  echo -e "\033[${bg1};${fg1}mMASK\033[0m = \033[${bg2};${fg2}m$(bash mask_calc.sh $PREFIX)\033[0m"
  echo -e "\033[${bg1};${fg1}mGATEWAY\033[0m = \033[${bg2};${fg2}m$(ip route | grep 'default via' | awk '{print $4}')\033[0m"
  echo -e "\033[${bg1};${fg1}mRAM_TOTAL\033[0m = \033[${bg2};${fg2}m$(free | grep 'Mem' | awk '{ printf "%.3f GB\n", $2/1048576 }')\033[0m"
  echo -e "\033[${bg1};${fg1}mRAM_USED\033[0m = \033[${bg2};${fg2}m$(free | grep 'Mem' | awk '{ printf "%.3f GB\n", $3/1048576 }')\033[0m"
  echo -e "\033[${bg1};${fg1}mRAM_FREE\033[0m = \033[${bg2};${fg2}m$(free | grep 'Mem' | awk '{ printf "%.3f GB\n", $4/1048576 }')\033[0m"
  echo -e "\033[${bg1};${fg1}mSPACE_ROOT\033[0m = \033[${bg2};${fg2}m$(df / | awk '/\// {printf "%.2f MB\n", substr($2, 1, $2)/1024}')\033[0m"
  echo -e "\033[${bg1};${fg1}mSPACE_ROOT_USED\033[0m = \033[${bg2};${fg2}m$(df  / | awk '/\// {printf "%.2f MB\n", substr($3, 1,$3)/1024}')\033[0m"
  echo -e "\033[${bg1};${fg1}mSPACE_ROOT_FREE\033[0m = \033[${bg2};${fg2}m$(df  / | awk '/\// {printf "%.2f MB\n", substr($4, 1, $4)/1024}')\033[0m"
}

# Вывод информации с заданными цветами
print_colored_info "$1" "$2" "$3" "$4"
