#! /bin/bash
# Script by Thomas Klinkenberg (2016)
#-------------------------------------------------------------------------------
echo
echo "---------------"
echo "---Executing--- $0 "
echo "---------------"
echo
#-------------------------------------------------------------------------------

# Wat er nog beter moet:
#   - Dat ie ten eerste spaties verwijderd uit bestandsnamen!
#   - De recursieve mix functie
#   - Dat is het voor nu

INDIR=$1

if [ $# -lt 1 ];
  then
    echo "Error with input directory"
    echo "No argument!"
    echo
    echo "... Exiting program"
    echo
    exit
fi

if [ -d $1 ]
  then
    echo "Input directory is $1"
    echo
  else
    echo "Error with input directory."
    echo "Can't find director $1"
    echo
    echo "... Exiting program"
    echo
    exit
  fi

if [ -d output ]
  then
    echo "Output directory already exist"
    echo "Puts converted files in directory output"
    echo
  else
    mkdir -p output
    echo "Output directory not found!"
    echo "Making new directory for output"
    echo
  fi

echo "Processing files..."
echo

cd $INDIR

for f in *.mp3;
  do
    LENGHTFLOAT=$(soxi -D $f)
    LENGHT=${LENGHTFLOAT%.*}
    SETOFF1=$(((RANDOM%($LENGHT - 5))+1))
    SETOFF2=$(((RANDOM%($LENGHT - 3))+1))
    SETOFF3=$(((RANDOM%($LENGHT - 2))+1))
    SETOFF4=$(((RANDOM%($LENGHT - 6))+1))
    PAN1=$(((RANDOM%(18))+1))
    PAN2=$(((RANDOM%(18))+1))
    file=$(basename $f .mp3)
    sox $f ../output/${file}_trim.wav trim $SETOFF1 5 norm -6 fade 0.1 0 0.1
    sox $f ../output/${file}_otherroom.wav trim $SETOFF2 3 lowpass 500 reverb 25 remix 1p-$PAN1 2p-$PAN2 2 norm -6 fade 0.1 0 0.1
    sox $f ../output/${file}_destruction.wav trim $SETOFF3 2 overdrive 20 20 overdrive 20 20 overdrive 20 20 norm -18 fade 0.1 0 0.1
    sox $f ../output/${file}_reverse.wav trim $SETOFF4 6 reverse fade 0.1 0 0.1 norm -6 fade 0.1 0 0.1
done

echo "... Done!"
echo
