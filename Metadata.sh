#!/bin/bash

TMPLEVEL=$1

DIRECTORY=$2
INPUTFILE=$3
TITLE=$4
DATE=$5
GENRE=$6
SHOW=$7
SEASON=$8
EPISODE=$9
LANGUAGE=${10}
QUALTIY=${11}
OUTPUTFILE=${12}

echo "Adding metadata"

if [ "$TMPLEVEL" > 1 ]; then
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" -loglevel warning "$DIRECTORY/TMP$OUTPUTFILE"
else
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" -loglevel warning "$DIRECTORY/$OUTPUTFILE"
fi
