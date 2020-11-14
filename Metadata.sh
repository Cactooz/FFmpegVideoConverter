#!/bin/bash

TMPLEVEL=$1

DIRECTORY=$2
INPUTFILE=$3
OUTPUTFILE=$4
TITLE=$5
DATE=$6
GENRE=$7
SHOW=$8
SEASON=$9
EPISODE=${10}
LANGUAGE=${11}
QUALTIY=${12}

echo "Adding metadata"

echo $OUTPUTFILE

if (( "$TMPLEVEL" > 1 )); then
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" -loglevel warning "$DIRECTORY/TMP$OUTPUTFILE"
else
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" -loglevel warning "$DIRECTORY/$OUTPUTFILE"
fi
