#!/bin/bash

TMPLEVEL=$1
TMPCHANGE=$2

DIRECTORY=$3
INPUTFILE=$4
ARTLOCATION=$5
OUTPUTFILE=$6

echo "Adding cover art"

if [ "$TMPCHANGE" = true ]; then
	if [ "$TMPLEVEL" > 2 ]; then
		ffmpeg -i "$DIRECTORY/2TMP$OUTPUTFILE" -i "$ARTLOCATION" -map 1 -map 0 -c copy -disposition:0 attached_pic -loglevel warning "$DIRECTORY/$OUTPUTFILE"
	elif [ "$TMPLEVEL" = 2 ]; then
		ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" -i "$ARTLOCATION" -map 1 -map 0 -c copy -disposition:0 attached_pic -loglevel warning "$DIRECTORY/$OUTPUTFILE"
	fi
else
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -i "$ARTLOCATION" -c copy -map 1 -map 0 -disposition:0 attached_pic "$DIRECTORY/$OUTPUTFILE"
fi
