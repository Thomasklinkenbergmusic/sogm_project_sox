#! /bin/bash
# Script by Thomas Klinkenberg (2016)
#-------------------------------------------------------------------------------
echo
echo "---Executing--- $0 "
echo
#-------------------------------------------------------------------------------

INDIR=$1
OUTDIR=$2

if [ $# -lt 1 ];
  then
    echo "Error with input directory"
    echo "No argument!"
    echo
    echo "... Exiting program"
    echo
    exit
fi

if [ $# -lt 2 ];
  then
    echo "Error with output directory"
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
    echo "Can't find directory $1"
    echo
    echo "... Exiting program"
    echo
    exit
  fi

if [ -d $2 ]
  then
    echo "Output directory already exist"
    echo "Puts converted files in directory output"
    echo
  else
    mkdir -p $2
    echo "Output directory not found!"
    echo "Making new directory for output"
    echo
  fi

{
  mkdir ./$2/out1_trimmed
  mkdir ./$2/out2_otherroom
  mkdir ./$2/out3_destruction
  mkdir ./$2/out4_reversed
} &> /dev/null


echo "Processing files..."
echo

# Makes a temporary map with all the .mp3 files
# Removes all spaces (convert to underscores)
# Converts all .mp3 to wav
#-------------------------------------------------------------------------------
cp -rf $INDIR ${INDIR}copy
cd ${INDIR}copy

for f in *;
  do
  oldname=`echo $f |sed 's/ /~/g'`
  newname=`echo $f |sed 's/ /_/g'`
  if [ $oldname != $newname ]
  then
    mv "$f" $newname
  fi
done

for f in *.mp3;
  do
    file=$(basename $f .mp3)
    sox $f ${file}.wav norm -6
    rm -rf $f
done

#-------------------------------------------------------------------------------
I=0

for f in *.wav;
  do
    LENGHTFLOAT=$(soxi -D $f)
    LENGHT=${LENGHTFLOAT%.*}
    SETOFF1=$(((RANDOM%($LENGHT - 5))+1))
    SETOFF2=$(((RANDOM%($LENGHT - 3))+1))
    SETOFF3=$(((RANDOM%($LENGHT - 2))+1))
    SETOFF4=$(((RANDOM%($LENGHT - 6))+1))
    file=$(basename $f .wav)
    sox $f ../$2/out1_trimmed/${file}_trim.wav trim $SETOFF1 5 norm -6 fade 0.1 0 0.1
    sox $f ../$2/out2_otherroom/${file}_otherroom.wav trim $SETOFF2 3 lowpass 250 reverb 10 norm -12 fade 0.1 0 0.1
    sox $f ../$2/out3_destruction/${file}_destruction.wav trim $SETOFF3 2 overdrive 20 20 overdrive 20 20 overdrive 20 20 norm -18 fade 0.1 0 0.1
    sox $f ../$2/out4_reversed/${file}_reversed.wav trim $SETOFF4 6 reverse fade 0.1 0 0.1 norm -6 fade 0.1 0 0.1
    I=$((I+1))
done
#-------------------------------------------------------------------------------

echo "I = $I"

for f in *.wav;
  do
    LENGTE=$(soxi -D $f)
    JAAA=$(bc <<< "scale=2; (($LENGTE / $I) / 60)")
    # echo $(bc <<< "scale=2; ($I/$AMTFILES)*100") "%";
    echo $JAAA
done
# rm -rf ../${INDIR}copy
