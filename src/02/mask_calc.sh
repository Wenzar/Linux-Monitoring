#!/bin/bash

# Функция для преобразования префикса в маску
prefix_to_mask() {
  local prefix="$1"
  local mask=""
  local num=0

  for ((i = 0; i < 32; i++)); do
    if [ "$i" -lt "$prefix" ]; then
      num=$((num | 1))
    fi

    if [ "$((i % 8))" -eq 7 ] || [ "$i" -eq 31 ]; then
      mask+="$num"
      if [ "$i" -ne 31 ]; then
        mask+="."
      fi
      num=0
    else
      num=$((num << 1))
    fi
  done
  echo "$mask"
}

# Проверяем, передан ли аргумент
if [ $# -eq 0 ]; then
  echo "Ошибка: Префикс не был передан."
  exit 1
fi

# Получаем значение префикса из аргумента
prefix="$1"

# Проверяем, что префикс является допустимым числом от 0 до 32
if ! [[ "$prefix" =~ ^[0-9]+$ ]] || [ "$prefix" -lt 0 ] || [ "$prefix" -gt 32 ]; then
  echo "Ошибка: Недопустимый префикс. Префикс должен быть числом от 0 до 32."
  exit 1
fi

# Вызываем функцию для преобразования префикса в маску и выводим результат
mask=$(prefix_to_mask "$prefix")
echo "$mask"
