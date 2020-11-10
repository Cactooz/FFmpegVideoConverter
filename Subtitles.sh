#!/bin/bash

TMPLEVEL=$1
TMPCHANGE=$2

DIRECTORY=$3
INPUTFILE=$4
SUBTITLE=$5
SUBTITLELANGUAGE=$6
OUTPUTFILE=$7

echo "Adding Subtitles"

if [ "$TMPCHANGE" = true ]; then
	if [ "$TMPLEVEL" > 2 ]; then
		ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/2TMP$OUTPUTFILE"
	else
		ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/$OUTPUTFILE"
	fi
else
	if [ "$TMPLEVEL" > 1 ]; then
		ffmpeg -i "$DIRECTORY/$INPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/TMP$OUTPUTFILE"
	else
		ffmpeg -i "$DIRECTORY/$INPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/$OUTPUTFILE"
	fi
fi
