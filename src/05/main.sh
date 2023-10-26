#!/bin/bash

#Начало выполнения скрипта
start_time=$(date +%s.%N)

# Проверка количества аргументов
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

# Переданный путь к каталогу
directory="$1"

# Подсчет общего числа папок (включая вложенные)
total_folders=$(find "$directory" -type d | wc -l)

# Поиск и вывод топ 5 папок с самым большим весом
echo "Total number of folders (including all nested ones) = $total_folders"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
find "$directory" -type d -exec du -sh {} \; | sort -rh | head -n 5

# Подсчет общего числа файлов
total_files=$(find "$directory" -type f | wc -l)

# Подсчет числа файлов различных типов
config_files=$(find "$directory" -type f -name "*.conf" | wc -l)
text_files=$(find "$directory" -type f -exec file {} \; | grep -c "text")
executable_files=$(find "$directory" -type f -executable | wc -l)
log_files=$(find "$directory" -type f -name "*.log" | wc -l)
archive_files=$(find "$directory" -type f -name "*.zip" -o -name "*.tar" | wc -l)
symbolic_links=$(find "$directory" -type l | wc -l)

# Вывод числа файлов различных типов
echo "Total number of files = $total_files"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $config_files"
echo "Text files = $text_files"
echo "Executable files = $executable_files"
echo "Log files (with the extension .log) = $log_files"
echo "Archive files = $archive_files"
echo "Symbolic links = $symbolic_links"

# Поиск и вывод топ 10 файлов с самым большим весом
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
find "$directory" -type f -exec du -h {} \; | sort -rh | head -n 10

# Поиск и вывод топ 10 исполняемых файлов с самым большим весом и хешем MD5
echo "TOP 10 executable files of maximum size arranged in descending order (path, size and MD5 hash of file)"
find "$directory" -type f -executable -exec du -h {} \; | sort -rh | head -n 10 | while read -r file_info; do
  file_path=$(echo "$file_info" | awk '{print $2}')
  file_size=$(echo "$file_info" | awk '{print $1}')
  md5_hash=$(md5sum "$file_path" | awk '{print $1}')
  echo "$file_path, $file_size, $md5_hash"
done

# Время выполнения скрипта
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc -l)
echo "Script execution time (in seconds) = $execution_time"
