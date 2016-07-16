export KALDI_ROOT=`pwd`/../../..
[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh
export PATH=$PWD/utils/:$KALDI_ROOT/tools/openfst/bin:$PWD:$PATH
[ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1
. $KALDI_ROOT/tools/config/common_path.sh

# Needed for "correct" sorting
export LC_ALL=C

# VoxForge data will be stored in:
export VOXFORGE_ROOT="/media/dados/resources/database/speech/pt-BR/voxforge-original-pt-16k-2016-07-16"    # e.g. something like /media/secondary/voxforge

if [ -z $VOXFORGE_ROOT ]; then
  echo "You need to set \"VOXFORGE_ROOT\" variable in path.sh to point to the directory to host VoxForge's data"
  exit 1
fi

export LAPS_ROOT="/media/dados/resources/database/speech/pt-BR/Laps-rnp" 

if [ -z $LAPS_ROOT ]; then
  echo "You need to set \"LAPS_ROOT\" variable in path.sh to point to the directory to host VoxForge's data"
  exit 1
fi





# we use this both in the (optional) LM training and the G2P-related scripts
PYTHON='python2.7'

### Below are the paths used by the optional parts of the recipe

# We only need the Festival stuff below for the optional text normalization(for LM-training) step
FEST_ROOT=tools/festival
NSW_PATH=${FEST_ROOT}/festival/bin:${FEST_ROOT}/nsw/bin
export PATH=$PATH:$NSW_PATH

# SRILM is needed for LM model building
SRILM_ROOT=$KALDI_ROOT/tools/srilm
SRILM_PATH=$SRILM_ROOT/bin:$SRILM_ROOT/bin/i686-m64
export PATH=$PATH:$SRILM_PATH

# Sequitur G2P executable
sequitur=$KALDI_ROOT/tools/sequitur/g2p.py
sequitur_path="$(dirname $sequitur)/lib/$PYTHON/site-packages"

# Directory under which the LM training corpus should be extracted
LM_CORPUS_ROOT=./lm-corpus









# Make sure that MITLM shared libs are found by the dynamic linker/loader
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/tools/mitlm-svn/lib

