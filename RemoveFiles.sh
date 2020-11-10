#!/bin/bash

DIRECTORY=$1
OUTPUTFILE=$2

echo "Removing temp files"

find $DIRECTORY -name "*TMP$OUTPUTFILE" -type f -exec rm -v {} \;
