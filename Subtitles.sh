#!/bin/bash

TMPLEVEL=$2
TMPCHANGE=$3

DIRECTORY=$4
INPUTFILE=$5
SUBTITLE=$6
SUBTITLELANGUAGE=$7
OUTPUTFILE=$8

ADDLOOP=true
SUBTITLEDIRLOOP=true

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
	echo "Adding Subtitles"

	if [ "$TMPCHANGE" = true ]; then
		if (( "$TMPLEVEL" > 2 )); then
			ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/2TMP$OUTPUTFILE"
		else
			ffmpeg -i "$DIRECTORY/TMP$OUTPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/$OUTPUTFILE"
		fi
	else
		if (( "$TMPLEVEL" > 1 )); then
			ffmpeg -i "$DIRECTORY/$INPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/TMP$OUTPUTFILE"
		else
			ffmpeg -i "$DIRECTORY/$INPUTFILE" -i "$SUBTITLE" -map 0 -map 1 -c copy -c:s mov_text -metadata:s:s:0 language="$SUBTITLELANGUAGE" -loglevel warning "$DIRECTORY/$OUTPUTFILE"
		fi
	fi
fi
