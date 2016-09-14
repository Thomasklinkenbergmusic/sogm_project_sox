#! /bin/bash

echo "Executing $0"

INFILE=$1
OUTFILE=$2
ARG3=$3
MPLAYERONOFF=$3
DURATION=$4
LENGHTFLOAT=$(soxi -D $INFILE)
LENGHT=${LENGHTFLOAT%.*}
SETOFF=$(((RANDOM%($LENGHT - $DURATION))+1))
STRETCH=2

# 
# if (( $DURATION > $LENGHT ))
# then
#   let STRETCH=4
#   echo "IF STATEMENT WERKT"
# fi
#
# echo $STRETCH
# HET LUKT NIET HELEMAAL
# Wat ik in ieder geval probeer is dat wanneer je een duration ($4) invult die
# langer is dan het originele bestand dat hij de stretch dan langer maakt,
# zodat hij langer de tijd heeft. Maar blijkbaar werkt dat niet helemaal goed.
#

sox --norm=-6 $INFILE $OUTFILE trim $SETOFF $DURATION reverse reverb -w stretch $STRETCH reverse trim 0 $DURATION lowpass 5000 22 reverb -w reverse STRETCH $STRETCH trim 0 $DURATION lowpass 500 3

rm -rf removefile.wav

if [ $MPLAYERONOFF = 1 ]
then
  play $OUTFILE
fi

# Derde argument moet 0 of 1 zijn. Bepaald of de file gelijk word afgespeeld.
