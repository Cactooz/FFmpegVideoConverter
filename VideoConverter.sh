#!/bin/bash

METADATALOOP=true
INSTALLFFMPEGLOOP=true
ARTLOOP=true

echo ""
echo "============================"
echo "Video Converter using FFmpeg"
echo "============================"


if ! FFMPEGLOCATION="$(command -v ffmpeg)" || [ -z $FFMPEGLOCATION ]; then
	echo ""
	echo "FFmpeg is not installed"
	echo "Do you want install it? (yes/no) "
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
read -p "Working directory (full path): " DIRECTORY
echo "This is now the working directory: $DIRECTORY"
echo ""
read -p "Input file: " INPUTFILE
echo ""

echo "Do you want to add metadata? (yes/no) "
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

			METADATALOOP=false
			;;
		[Nn]* )
			METADATALOOP=false
			;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo ""

echo "Do you want to add cover art? (yes/no) "
while [ "$ARTLOOP" = true ]
do
	read ARTANSWER
	case $ARTANSWER in
		[Yy]* )
			echo ""

			read -p "Cover art file (keep it in the same folder): " ARTFILE
			
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

if [ "$USEART" = true ]; then
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -loglevel warning -c:s  mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" "$DIRECTORY/TMP-$OUTPUTFILE"
	ffmpeg -i "$DIRECTORY/TMP-$OUTPUTFILE" -i "$DIRECTORY/$ARTFILE" -c copy -loglevel warning -map 1 -map 0 -disposition:0 attached_pic "$DIRECTORY/$OUTPUTFILE"
	rm "$DIRECTORY/TMP-$OUTPUTFILE"
else
	ffmpeg -i "$DIRECTORY/$INPUTFILE" -c copy -loglevel warning -c:s mov_text -metadata title="$TITLE" -metadata date="$DATE" -metadata genre="$GENRE" -metadata show="$SHOW" -metadata season_number="$SEASON" -metadata episode_id="$EPISODE" -metadata episode_sort="$EPISODE" -metadata language="$LANGUAGE" -metadata hd_video="$QUALTIY" "$DIRECTORY/$OUTPUTFILE"
fi

echo ""
echo "DONE!"
echo ""
