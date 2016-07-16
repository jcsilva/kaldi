#!/bin/bash

# Copyright 2016 Jose Eduardo
# Apache 2.0

source path.sh

lapsdata=data/laps
lapstmp=$lapsdata/tmp
rm -rf $lapstmp >/dev/null 2>&1
mkdir -p $lapstmp
mkdir -p $lapsdata

echo "==== Starting initial Laps data preparation ..."

#prepare text
echo "====Preparing text..."
cp ${LAPS_ROOT}/16k/text $lapstmp/text
cut -d' ' -f1 $lapstmp/text > $lapstmp/text.1
cut -d' ' -f2- $lapstmp/text > $lapstmp/text.2
#everything is going to be in upper case
cat $lapstmp/text.2 | PERLIO=:utf8 perl -pe '$_=uc' > $lapstmp/text.2.upper
paste $lapstmp/text.1 $lapstmp/text.2.upper > $lapstmp/text.upper
sort $lapstmp/text.upper > $lapsdata/text

#prepare wav.scp
echo "====Preparing wav.scp..."
find ${LAPS_ROOT}/16k -iname \*.wav > $lapstmp/wavs.txt
rm -f $lapstmp/wav.scp

while read -r line
do
    path=$(dirname "$line")
    pathid=$(echo $(basename "$path") | cut -d'-' -f2)
    filename=$(basename "$line")
    fileid=$(echo "$filename" | cut -d'_' -f2 | cut -d'.' -f1)
    echo "${pathid}-${fileid} ${line}" >> $lapstmp/wav.scp
done < $lapstmp/wavs.txt

sort $lapstmp/wav.scp > $lapsdata/wav.scp

#prepare utt2spk
echo "====Preparing utt2spk..."
cut -d' ' -f1 $lapsdata/wav.scp > $lapstmp/utts.txt
cut -d'-' -f1 $lapstmp/utts.txt > $lapstmp/spks.txt
paste $lapstmp/utts.txt $lapstmp/spks.txt > $lapsdata/utt2spk

#prepare spk2gender
echo "====Preparing spk2gender..."
cut -d'0' -f1 $lapstmp/spks.txt |  perl -ne 'print lc' > $lapstmp/gender.txt
paste $lapstmp/spks.txt $lapstmp/gender.txt > $lapsdata/spk2gender

echo "*** Initial Laps data preparation finished!"
