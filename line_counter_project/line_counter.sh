#!/bin/bash

MAIN_FILE="real_file.txt"
BACKUP_FILE="backup_file.txt"
MAX_LINES=100

touch "$MAIN_FILE" "$BACKUP_FILE"

echo "Please input your lines:"
cat >> "$MAIN_FILE"

while [ "$(wc -l < "$MAIN_FILE")" -gt "$MAX_LINES" ]; do
    head -n 1 "$MAIN_FILE" >> "$BACKUP_FILE"
    tail -n +2 "$MAIN_FILE" > temp_file && mv temp_file "$MAIN_FILE"
done

echo "Update complete."
echo "Main file lines   : $(wc -l < "$MAIN_FILE")"
echo "Backup file lines : $(wc -l < "$BACKUP_FILE")"
