#!/bin/bash

METADATALOOP=true
INSTALLFFMPEGLOOP=true
ARTLOOP=true
ARTDIRLOOP=true
SUBTITLELOOP=true
SUBTITLEDIRLOOP=true
TMPLEVEL=0
TMPCHANGE=false

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
			TMPLEVEL=$((TMPLEVEL+1))
			TMPCHANGE=true
			;;
		[Nn]* )
			METADATALOOP=false
			;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo ""

echo "Do you want to add subtitles? (yes/no)"
while [ "$SUBTITLELOOP" = true ]
do
	read SUBTITLEANSWER
	case $SUBTITLEANSWER in
		[Yy]* )
			echo ""

			echo "Is the subtitles in the same directory as: $DIRECTORY? (yes/no)"
			while [ "$SUBTITLEDIRLOOP" = true ]
			do
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

			echo ""
			read -p "Subtitle file: " SUBTITLEFILE

			SUBTITLE=$SUBTITLEDIR/$SUBTITLEFILE

			echo ""
			read -p "Subtitle language (example: eng): " SUBTITLELANGUAGE

			USESUBTITLES=true
			SUBTITLELOOP=false
			TMPLEVEL=$((TMPLEVEL+1))
			TMPCHANGE=true
			;;
		[Nn]* )
			SUBTITLELOOP=false
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
			TMPLEVEL=$((TMPLEVEL+1))
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

echo "Converting file..."

if [ "$USEMETADATA" = true ]; then
	./Metadata.sh $TMPLEVEL $DIRECTORY $INPUTFILE $TITLE $DATE $GENRE $SHOW $SEASON $EPISODE $LANGUAGE $QUALTIY $OUTPUTFILE
fi

if [ "$USESUBTITLES" = true ]; then
	./Subtitles.sh $TMPLEVEL $TMPCHANGE $DIRECTORY $INPUTFILE $SUBTITLE $SUBTITLELANGUAGE $OUTPUTFILE
fi

if [ "$USEART" = true ]; then
	./CoverArt.sh $TMPLEVEL $TMPCHANGE $DIRECTORY $INPUTFILE $ARTLOCATION $OUTPUTFILE
fi

./RemoveFiles.sh $DIRECTORY $OUTPUTFILE

echo ""
echo "DONE!"
echo ""
