#!/bin/bash

DIRECTORY=$2
INPUTFILEEND=$3
OUTPUTFILEEND=$4

shopt -s nullglob
FILES=($DIRECTORY/*.$FILEEND)

for FILE in $FILES; do
  FILENAME=${FILE%.*}
  
  ffmpeg -i "$DIRECTORY/$FILE" -c copy -c:s mov_text -loglevel warning "$DIRECTORY/$FILENAME.$OUTPUTFILEEND"
done
