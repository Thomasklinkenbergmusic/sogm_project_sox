#! /bin/bash

echo "Executing $0"

INFILE=$1
OUTFILE=$2
MPLAYONOFF=$3
LENGHTFLOAT=$(soxi -D $INFILE)
LENGHT=${LENGHTFLOAT%.*}
SETOFF=$(((RANDOM%($LENGHT - 5))+1))

# Pakt nu elke keer random 5 seconde uit het nummer

sox --norm=-6 $INFILE $OUTFILE trim $SETOFF 5
