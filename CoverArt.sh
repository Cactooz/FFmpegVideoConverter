#!/bin/bash

TMPLEVEL=$1

DIRECTORY=$2
INPUTFILE=$3
ARTLOCATION=$4
OUTPUTFILE=$5

echo "Adding cover art"

if (( "$TMPLEVEL" == 1 )); then
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -i "$ARTLOCATION" -c copy -map 1 -map 0 -disposition:0 attached_pic -loglevel warning "$DIRECTORY/$OUTPUTFILE"
elif (( "$TMPLEVEL" == 2 )); then
	ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" -i "$ARTLOCATION" -map 1 -map 0 -c copy -disposition:0 attached_pic -loglevel warning "$DIRECTORY/$OUTPUTFILE"
elif (( "$TMPLEVEL" == 3 )); then
	ffmpeg -i "$DIRECTORY/2TMP$OUTPUTFILE" -i "$ARTLOCATION" -map 1 -map 0 -c copy -disposition:0 attached_pic -loglevel warning "$DIRECTORY/$OUTPUTFILE"
fi
