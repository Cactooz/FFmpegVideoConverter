#!/bin/bash

METADATALOOP=true
INSTALLFFMPEGLOOP=true
ARTLOOP=true
ARTDIRLOOP=true

echo ""
echo "============================"
echo "Video Converter using FFmpeg"
echo "============================"


if ! FFMPEGLOCATION="$(command -v ffmpeg)" || [ -z $FFMPEGLOCATION ]; then
	echo ""
	echo "FFmpeg is not installed"
	echo "Do you want install it? (yes/no)"
	while [ "$INSTALLFFMPEGLOOP" = true ]
	do
		read INSTALLFFMPEGANSWER
		case $INSTALLFFMPEGANSWER in
			[Yy]* )
				sudo apt install ffmpeg -y

				INSTALLFFMPEGLOOP=false
				;;
			[Nn]* )
				echo "Sadly you can't use this script without FFmpeg"
				exit
				;;
			* ) echo "Please answer yes or no.";;
		esac
	done
fi

echo ""
read -p "Working directory (full path or . to use current directory): " DIRECTORY
if [ "$DIRECTORY" = "." ]; then
	echo "Using current directory"
else
	echo "This is now the working directory: $DIRECTORY"
fi

echo ""
read -p "Input file: " INPUTFILE
echo ""

echo "Do you want to add metadata? (yes/no)"
while [ "$METADATALOOP" = true ]
do
	read METADATAANSWER
	case $METADATAANSWER in
		[Yy]* )
			echo ""

			read -p "Title: " TITLE
			read -p "Release date (number): " DATE
			read -p "Genre: " GENRE
			read -p "Show name: " SHOW
			read -p "Season number (number): " SEASON
			read -p "Episode number (number): " EPISODE
			read -p "Language: " LANGUAGE
			read -p "Resolution (SD=0, 720p=1, 1080p=2, 2160p=3): " QUALTIY

			USEMETADATA=true
			METADATALOOP=false
			;;
		[Nn]* )
			METADATALOOP=false
			;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo ""

echo "Do you want to add cover art? (yes/no)"
while [ "$ARTLOOP" = true ]
do
	read ARTANSWER
	case $ARTANSWER in
		[Yy]* )
			echo ""

			echo "Is the cover art in the same directory as: $DIRECTORY? (yes/no)"
			while [ "$ARTDIRLOOP" = true ]
			do
				read ARTDIRANSWER
				case $ARTDIRANSWER in
					[Yy]* )
						ARTDIR=$DIRECTORY

						ARTDIRLOOP=false
						;;
					[Nn]* )
						echo ""
						read -p "Directory for cover art: " ARTDIR

						ARTDIRLOOP=false
						;;
					* ) echo "Please answer yes or no.";;
				esac
			done

			echo ""
			read -p "Cover art file: " ARTFILE

			ARTLOCATION=$ARTDIR/$ARTFILE

			USEART=true
			ARTLOOP=false
			;;
		[Nn]* )
			ARTLOOP=false
			;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo ""
read -p "Output file: " OUTPUTFILE
echo ""

if [ "$USEMETADATA" = true ]; then
	if [ "$USEART" = true ]; then
		echo "Converting file"
		echo "Writing metadata"
		ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -loglevel warning -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" "$DIRECTORY/TMP-$OUTPUTFILE"
		echo "Adding cover art"
		ffmpeg -i "$DIRECTORY/TMP-$OUTPUTFILE" -i "$ARTLOCATION" -c copy -loglevel warning -map 1 -map 0 -disposition:0 attached_pic "$DIRECTORY/$OUTPUTFILE"
		echo "Removing temp files"
		rm "$DIRECTORY/TMP-$OUTPUTFILE"
	else
		echo "Converting file"
		ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -loglevel warning -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" "$DIRECTORY/$OUTPUTFILE"
	fi
else
	if [ "$USEART" = true ]; then
		echo "Converting file"
		ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -loglevel warning -c:s mov_text "$DIRECTORY/TMP-$OUTPUTFILE"
		echo "Adding cover art"
		ffmpeg -i "$DIRECTORY/TMP-$OUTPUTFILE" -i "$ARTLOCATION" -c copy -loglevel warning -map 1 -map 0 -disposition:0 attached_pic "$DIRECTORY/$OUTPUTFILE"
		echo "Removing temp files"
		rm "$DIRECTORY/TMP-$OUTPUTFILE"
	else
		echo "Converting file"
		ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -loglevel warning -c:s mov_text "$DIRECTORY/$OUTPUTFILE"
	fi
fi

echo ""
echo "DONE!"
echo ""
