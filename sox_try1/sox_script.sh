#! /bin/bash

echo "Executing $0"

INFILE=$1
OUTFILE=$2
MPLAYONOFF=$3
LENGHTFLOAT=$(soxi -D $INFILE)
LENGHT=${LENGHTFLOAT%.*}
SETOFF=$(((RANDOM%($LENGHT - 5))+1))

# Pakt nu elke keer random 5 seconde uit het nummer

sox --norm=-6 $INFILE rm1.wav trim $SETOFF 5
sox --norm=-6 rm1.wav rm2.wav reverse
sox --norm=-6 rm2.wav $OUTFILE reverse

rm -rf rm1.wav
rm -rf rm2.wav

# Een beetje omslachtig, maar het systeem maakt nu rm1.wav,
# bewerkt die en maakt weer een nieuwe aan. Eigenlijk wil je dat hij de hele
# tijd zichzelf bewerkt. Alleen werkt het volgende niet:

# sox --norm=-6 rm1.wav rm1.wav reverse reverb

# Dan geeft hij errors
