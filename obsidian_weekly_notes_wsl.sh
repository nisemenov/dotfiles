#!/bin/bash

if [ -z "$1" ]; then
    python /mnt/c/Users/nisemenov/Documents/obsidian/weekly_notes.py
else
    python /mnt/c/Users/nisemenov/Documents/obsidian/weekly_notes.py "$1"
fi
