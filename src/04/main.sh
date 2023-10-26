#!/bin/bash

source config.conf

#Дефолтные цвета
column_1_background_default=6
column_1_text_default=1
column_2_background_default=1
column_2_text_default=6

        color_name=("white" "red" "green" "blue" "purple" "black")

# Проверка количества переданных параметров
if [ $# -gt 0 ]; then
  echo "Ошибка: Параметры не требуются."
  exit 1
fi

# Проверка допустимых значений параметров
valid_colors=(1 2 3 4 5 6 -z)
if ! [[ " ${valid_colors[*]} " =~ " $column1_background " || -z $column1_background ]] || ! [[ " ${valid_colors[*]} " =~ " $column1_font_color " || -z $column1_font_color ]] || \
   ! [[ " ${valid_colors[*]} " =~ " $column2_background " || -z $column2_background ]] || ! [[ " ${valid_colors[*]} " =~ " $column2_font_color " || -z $column2_font_color ]]; then
  echo "Ошибка: Недопустимые значения параметров. Параметры должны быть числами от 1 до 6."
  exit 1
fi

# Проверка на наличие значений из конфига
flag_cb1=0
flag_cf1=0
flag_cb2=0
flag_cf2=0
if [[ -z $column1_background ]]
then
  column1_background=$column_1_background_default
  flag_cb1=1
fi 

if [[ -z $column1_font_color ]]
then
  column1_font_color=$column_1_text_default
  flag_cf1=1
fi 

if [[ -z $column2_background ]]
then
  column2_background=$column_2_background_default
  flag_cb2=1
fi 

if [[ -z $column2_font_color ]]
then
  column2_font_color=$column_2_text_default
  flag_cf2=1
fi 

# Проверка, что цвета шрифта и фона не совпадают
if [ "$column1_background" -eq "$column1_font_color" ] || [ "$column2_background" -eq "$column2_font_color" ]; then
  echo "Ошибка: Цвета шрифта и фона должны различаться. Попробуйте еще раз!"
  exit 1
fi

# Функция для вывода информации с заданными цветами
print_colored_info() {
  local fg_name=("White" "Red" "Green" "Blue" "Purple" "Black")
  local bg_color=("47" "41" "42" "44" "45" "40")
  local fg_color=("37" "31" "32" "34" "35" "30")

  local bg1="${bg_color[column1_background-1]}"
  local fg1="${fg_color[column1_font_color-1]}"
  local bg2="${bg_color[column2_background-1]}"
  local fg2="${fg_color[column2_font_color-1]}"
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
print_colored_info "$column1_background" "$column1_font_color" "$column2_background" "$column2_font_color"

echo ""
if [[ "$flag_cb1" -eq 1 ]]
then
 echo "Column 1 background = default (${color_name[column_1_background_default-1]})"
else
 echo "Column 1 background = $column1_background (${color_name[column1_background-1]})"
fi

if [[ "$flag_cf1" -eq 1 ]]
then
 echo "Column 1 font color = default (${color_name[column_1_text_default-1]})"
else
 echo "Column 1 font color = $column1_font_color (${color_name[column1_font_color-1]})"
fi

if [[ "$flag_cb2" -eq 1 ]]
then
 echo "Column 2 background = default (${color_name[column_2_background_default-1]})"
else
 echo "Column 2 background = $column2_background (${color_name[column2_background-1]})"
fi

if [[ "$flag_cf2" -eq 1 ]]
then
 echo "Column 2 font color = default (${color_name[column_2_text_default-1]})"
else
 echo "Column 2 font color = $column2_font_color (${color_name[column2_font_color-1]})"
fi