#!/bin/bash

TMPLEVEL=$2
TMPCHANGE=$3

DIRECTORY=$4
INPUTFILE=$5
OUTPUTFILE=$6

ADDLOOP=true
SUBTITLEDIRLOOP=true

getData() {
	readData() {
		local FILE="$DIRECTORY/$1"
		DATA=
		while IFS= read -r LINE; do
			DATA="$DATA $LINE"
		done < "$FILE"
	}

	readData AddSubtitleFile.txt
	SUBTITLEFILEDATA=$DATA

	readData AddSubtitleMap.txt
	SUBTITLEMAPDATA=$DATA

	readData AddSubtitleLanguage.txt
	SUBTITLELANGUAGEDATA=$DATA
}

if [ "$1" = "-a" ]; then

	echo ""

	echo "Is the subtitles in the same directory as: $DIRECTORY? (yes/no)"
	while [ "$SUBTITLEDIRLOOP" = true ]; do
		read SUBTITLEDIRANSWER
		case $SUBTITLEDIRANSWER in
			[Yy]* )
				SUBTITLEDIR=$DIRECTORY

				SUBTITLEDIRLOOP=false
				;;
			[Nn]* )
				echo ""
				read -p "Directory for subtitles: " SUBTITLEDIR

				SUBTITLEDIRLOOP=false
				;;
			* ) echo "Please answer yes or no.";;
		esac
	done

	while [ "$ADDLOOP" = true ]; do
		if (( "$TMPLEVEL" > 0 )); then
			echo ""
			read -p "Do you want to add another subtitle? (yes/no) " ADDANSWER
		else
			ADDANSWER=y
		fi
		case $ADDANSWER in
			[Yy]* )
				echo ""
				read -p "Subtitle file: " SUBTITLEFILE

				SUBTITLE=$SUBTITLEDIR/$SUBTITLEFILE

				echo ""
				read -p "Subtitle language (example: eng/swe): " SUBTITLELANGUAGE
				
				echo "-i $SUBTITLE" >> $DIRECTORY/AddSubtitleFile.txt
				echo "-metadata:s:s:$TMPLEVEL language="$SUBTITLELANGUAGE"" >> $DIRECTORY/AddSubtitleLanguage.txt
				
				TMPLEVEL=$((TMPLEVEL+1))
				echo "-map $TMPLEVEL" >> $DIRECTORY/AddSubtitleMap.txt
				;;
			[Nn]* )
				ADDLOOP=false
				;;
			* ) echo "Please answer yes or no.";;
		esac
	done
fi

if [ "$1" = "-x" ]; then
	echo "Getting Subtitle Data"

	getData

	echo "Adding Subtitles"

	if (( "$TMPLEVEL" == 1 )); then
		ffmpeg -i "$DIRECTORY/$INPUTFILE" $SUBTITLEFILEDATA -map 0 $SUBTITLEMAPDATA -c copy -c:s mov_text $SUBTITLELANGUAGEDATA -loglevel warning "$DIRECTORY/$OUTPUTFILE"
	elif (( "$TMPLEVEL" == 2 )); then
		if [ "$TMPCHANGE" = true ]; then
			ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" $SUBTITLEFILEDATA -map 0 $SUBTITLEMAPDATA -c copy -c:s mov_text $SUBTITLELANGUAGEDATA -loglevel warning "$DIRECTORY/$OUTPUTFILE"
		else
			ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" $SUBTITLEFILEDATA -map 0 $SUBTITLEMAPDATA -c copy -c:s mov_text $SUBTITLELANGUAGEDATA -loglevel warning "$DIRECTORY/2TMP$OUTPUTFILE"
		fi
	elif (( "$TMPLEVEL" == 3 )); then
		ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" $SUBTITLEFILEDATA -map 0 $SUBTITLEMAPDATA -c copy -c:s mov_text $SUBTITLELANGUAGEDATA -loglevel warning "$DIRECTORY/2TMP$OUTPUTFILE"
	fi
fi
