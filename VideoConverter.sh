#!/bin/bash

METADATALOOP=true
INSTALLFFMPEGLOOP=true
ARTLOOP=true
ARTDIRLOOP=true
SUBTITLELOOP=true
TMPLEVEL=0
TMPCHANGE=false

echo ""
echo "============================"
echo "Video Converter using FFmpeg"
echo "============================"

if [ "$1" = "-h" ]; then
	echo ""
	echo "DESCRIPTION"
	echo "A video converter Script using FFmpeg for Linux."
	echo "Can add metadata, subtitles and cover art to the video."
	echo ""
	echo "COMMAND LAYOUT"
	echo "./VideoConverter.sh"
	echo ""
	echo "NEEDED SCRIPTS"
	echo "Metadata.sh for adding metadata"
	echo "Subtitles.sh for adding subtitles"
	echo "CoverArt.sh for adding subtitles"
	echo "RemoveFiles.sh to remove temp files"
	echo "BulkConvert.sh in order to convert multiple files in a folder"
	echo ""

	exit 0
fi

if ! FFMPEGLOCATION="$(command -v ffmpeg)" || [ -z $FFMPEGLOCATION ]; then
	echo ""
	echo "FFmpeg is not installed"
	echo "Do you want install it? (yes/no)"
	while [ "$INSTALLFFMPEGLOOP" = true ]; do
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

if [ "$1" = "-b" ]; then
	echo ""
	echo "Bulk conversion"
	
	read -p "Convert from file format: " $INPUTFORMAT
	read -p "Convert to file format: " $OUTPUTFORMAT
	
	./BulkConvert.sh $DIRECTORY $INPUTFORMAT $OUTPUTFORMAT

	echo ""
	echo "DONE!"
	echo ""
	
	exit 0
fi

echo ""
read -p "Input file: " INPUTFILE
echo ""

echo "Do you want to add metadata? (yes/no)"
while [ "$METADATALOOP" = true ]; do
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
while [ "$SUBTITLELOOP" = true ]; do
	read SUBTITLEANSWER
	case $SUBTITLEANSWER in
		[Yy]* )
			./Subtitles.sh -a 0 - $DIRECTORY

			USESUBTITLES=true
			SUBTITLELOOP=false
			TMPLEVEL=$((TMPLEVEL+1))
			;;
		[Nn]* )
			SUBTITLELOOP=false
			;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo ""

echo "Do you want to add cover art? (yes/no)"
while [ "$ARTLOOP" = true ]; do
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
echo ""

if [ "$USEMETADATA" = true ]; then
	./Metadata.sh $TMPLEVEL $DIRECTORY $INPUTFILE $OUTPUTFILE $TITLE $DATE $GENRE $SHOW $SEASON $EPISODE $LANGUAGE $QUALTIY
fi

if [ "$USESUBTITLES" = true ]; then
	./Subtitles.sh -x $TMPLEVEL $TMPCHANGE $DIRECTORY $INPUTFILE $OUTPUTFILE
fi

if [ "$USEART" = true ]; then
	./CoverArt.sh $TMPLEVEL $DIRECTORY $INPUTFILE $ARTLOCATION $OUTPUTFILE
fi

./RemoveFiles.sh $DIRECTORY $OUTPUTFILE

echo ""
echo "DONE!"
echo ""
