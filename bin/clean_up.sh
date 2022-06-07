#!/usr/bin/env bash


ARCHIVE=~/Downloads/_archive


for DIR in ~/Downloads ~/Desktop
do
    # Handle images
    find $DIR \
         -maxdepth 1 \
         -type f \
         -mtime +1 \
         \( \
         -iname '*.jpg' \
         -o -iname '*.jpeg' \
         -o -iname '*.png' \
         -o -iname '*.gif' \
         -o -iname '*.tiff' \
         -o -iname '*.pxm' \
         \) \
         -execdir mv -f '{}' $ARCHIVE/_images/ \;

    # Handle archives
    find $DIR \
         -maxdepth 1 \
         -type f \
         -mtime +1 \
         \( \
         -iname '*.tar' \
         -o -iname '*.gz' \
         -o -iname '*.tgz' \
         -o -iname '*.bz2' \
         -o -iname '*.7z' \
         -o -iname '*.rar' \
         -o -iname '*.zip' \
         -o -iname '*.dmg' \
         \) \
         -execdir mv -f '{}' $ARCHIVE/_zips/ \;


    # Handle PDFs
    find $DIR \
         -maxdepth 1 \
         -type f \
         -mtime +1 \
         -iname '*.pdf' \
         -execdir mv -f '{}' $ARCHIVE/_PDFs/ \;

    # Handle everything else
    find $DIR \
         -maxdepth 1 \
         -type f \
         -mtime +1 \
         -iname '*' \
         -execdir mv -f '{}' $ARCHIVE/ \;

done
