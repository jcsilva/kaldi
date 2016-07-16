#!/bin/bash

# Copyright 2016 Jose Eduardo
# Apache 2.0

# Downloads and extracts the data from Laps

# defines the "LAPS_ROOT" variable - the location to store data 
source ./path.sh

DATA_SRC="http://www.laps.ufpa.br/falabrasil/files/LapsBM1.4.rar"

if [ ! -f ${LAPS_ROOT}/LapsBM1.4.rar ]; then
    # Check if the executables needed for this script are present in the system
    command -v wget >/dev/null 2>&1 ||\
     { echo "\"wget\" is needed but not found"'!'; exit 1; }

    echo "--- Starting VoxForge data download (may take some time) ..."
    wget -P ${LAPS_ROOT} -l 1 -N -nd -c -e robots=off -r -np ${DATA_SRC} || \
     { echo "WGET error"'!' ; exit 1 ; }
fi

#uncompress files to ${LAPS_ROOT}/LapsBM1.4
unrar x ${LAPS_ROOT}/LapsBM1.4.rar ${LAPS_ROOT}

#downsample original files to 16 kHz
mkdir -p ${LAPS_ROOT}/16k 2> /dev/null
find ${LAPS_ROOT}/LapsBM1.4 -iname \*.wav > tmp.txt

while read -r line
do
    filename=$(basename "$line")
    path=$(dirname "$line")
    newpath=$(echo $path | sed 's/LapsBM1.4/16k/')
    rm -f ${newpath}/${filename}
    mkdir -p ${newpath} 2> /dev/null
    sox ${line} -r 16000 ${newpath}/${filename}
done < tmp.txt


#create transcription file
rm -f ${LAPS_ROOT}/16k/text
find ${LAPS_ROOT} -iname \*.txt > tmp.txt
while read -r line
do
    path=$(dirname "$line")
    pathid=$(echo $(basename "$path") | cut -d'-' -f2)
    filename=$(basename "$line")
    fileid=$(echo "$filename" | cut -d'_' -f2 | cut -d'.' -f1)
    echo "${pathid}-${fileid} $(cat $line)" >> ${LAPS_ROOT}/16k/text
done < tmp.txt

rm tmp.txt
