#!/bin/bash

. path.sh || exit 1

locdata=data/local
locdict=$locdata/dict

echo "=== Preparing the dictionary ..."

if [ ! -f $locdict/g2p/multilingual-g2p-master/g2p.sh ]; then
  echo "--- Downloading G2P ..."
  wget https://github.com/jcsilva/multilingual-g2p/archive/master.zip -P $locdict/g2p || exit 1;
  unzip $locdict/g2p/master.zip -d $locdict/g2p/
fi

$locdict/g2p/multilingual-g2p-master/g2p.sh -w $locdata/vocab-full.txt > $locdict/lexicon.txt


echo "--- Prepare phone lists ..."
echo SIL > $locdict/silence_phones.txt
echo SIL > $locdict/optional_silence.txt
grep -v -w sil $locdict/lexicon.txt | \
  awk '{for(n=2;n<=NF;n++) { p[$n]=1; }} END{for(x in p) {print x}}' |\
  sort > $locdict/nonsilence_phones.txt

echo "--- Adding SIL to the lexicon ..."
echo -e "!SIL\tSIL" >> $locdict/lexicon.txt

# Some downstream scripts expect this file exists, even if empty
touch $locdict/extra_questions.txt

echo "*** Dictionary preparation finished!"
