#! /bin/bash
# Script by Thomas Klinkenberg (2016)
#-------------------------------------------------------------------------------
echo
echo "---Executing--- $0 "
echo
#-------------------------------------------------------------------------------

INDIR=$1
OUTDIR=$2

PROGRAM=0
# Function for the minute mix
function randomfile() {
     files=(*)
     echo "${files[RANDOM % ${#files[@]}]}"
}

# Gives error when first argument is not found
if [ $# -lt 1 ];
  then
    echo "Error with input directory"
    echo "No valid first argument!"
    echo "First argument is the input directory"
    echo "... Exiting program"
    echo
    exit
fi

# Gives error when second argument is not found
if [ $# -lt 2 ];
  then
    echo "Error with output directory"
    echo "No valid second argument!"
    echo "Second argument is the output directory"
    echo
    echo "... Exiting program"
    echo
    exit
fi

# Confirms when input directory is valid OR gives error when input directory is invalid
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

# Gives comment when output directory already exist OR gives comment making a new output directory
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

# Making new outputs in $OUTDIR. If the directory's already exist; program won't give any errors (-p)
mkdir -p ./$OUTDIR/out1_trimmed
mkdir -p ./$OUTDIR/out2_otherroom
mkdir -p ./$OUTDIR/out3_destruction
mkdir -p ./$OUTDIR/out4_reversed

echo "Processing files..."
echo

# Makes copy of entire input directory
cp -rf $INDIR ${INDIR}copy
cd ${INDIR}copy

# Script by Marc Groenewegen - removes possible spaces from .mp3 files
for f in *;
  do
  oldname=`echo $f |sed 's/ /~/g'`
  newname=`echo $f |sed 's/ /_/g'`
  if [ $oldname != $newname ]
  then
    mv "$f" $newname
  fi
done

# Converts all .mp3 files to wav with same samplerate of 44100
{
  for f in *.mp3;
    do
      file=$(basename $f .mp3)
      sox -S $f ${file}_44k.wav rate -L -s 44100
      sox ${file}_44k.wav ${file}.wav norm -6
      rm -rf ${file}_44k.wav
      rm -rf $f
  done
} &> /dev/null

# Makes seperated trimmed files with effects.
I=0
for f in *.wav;
  do
    LENGTH=$(soxi -D $f)
    LENGTH=${LENGTH%.*}
    SETOFF1=$(((RANDOM%($LENGTH - 5))+1))
    SETOFF2=$(((RANDOM%($LENGTH - 3))+1))
    SETOFF3=$(((RANDOM%($LENGTH - 3))+1))
    SETOFF4=$(((RANDOM%($LENGTH - 5))+1))
    file=$(basename $f .wav)
    sox $f ../$OUTDIR/out1_trimmed/${file}_trim.wav trim $SETOFF1 5 norm -6 fade 0.1 0 0.1
    sox $f ../$OUTDIR/out2_otherroom/${file}_otherroom.wav trim $SETOFF2 3 lowpass 250 reverb 10 norm -12 fade 0.1 0 0.1
    sox $f ../$OUTDIR/out3_destruction/${file}_destruction.wav trim $SETOFF3 2 overdrive 20 20 overdrive 20 20 overdrive 20 20 norm -18 fade 0.1 0 0.1
    sox $f ../$OUTDIR/out4_reversed/${file}_reversed.wav trim $SETOFF4 5 reverse fade 0.1 0 0.1 norm -6 fade 0.1 0 0.1
    I=$((I+1))
done

# Determine length of each individual file for minutemix. Removes copy of input directory afterwards
TRIMLENGTH=$(bc <<< "scale=2; (60 / $I)")
mkdir -p ../$OUTDIR/minutemix
for f in *.wav;
  do
    LENGTH=$(soxi -D $f)
    LENGTH=${LENGTH%.*}
    TRIMTRIM=${TRIMLENGTH%.*}
    LENGTH=$((LENGTH-TRIMTRIM))
    SETOFF=$(((RANDOM%($LENGTH - $TRIMTRIM))+1))
    VOLUME=$(((RANDOM%17)+1))
    file=$(basename $f .wav)
    sox $f ../$OUTDIR/minutemix/${file}_trim.wav trim $SETOFF $TRIMLENGTH remix - norm -18 gain $VOLUME fade 0.1 0 0.1
done
rm -rf ../${INDIR}copy

cd ../$OUTDIR/minutemix

FIRSTTEMP=$(randomfile)
mv $FIRSTTEMP ../$FIRSTTEMP
SECONDTEMP=$(randomfile)
mv ../$FIRSTTEMP $FIRSTTEMP

X=1
{
  for f in *.wav;
    do
      Y=1
      FILE=$(randomfile)
      if [ $X == $Y ];
        then
          sox $FIRSTTEMP $SECONDTEMP ../wavtemp.wav
          rm -rf $FIRSTTEMP
          rm -rf $SECONDTEMP
          mv ../wavtemp.wav ../minutemix.wav
        else
          sox ../minutemix.wav $FILE ../wavtemp.wav
          rm -rf minutemix.wav
          rm -rf $FILE
          mv ../wavtemp.wav ../minutemix.wav
        fi
      X=$((X+1))
  done
} &> /dev/null

rm -rf ../minutemix

echo
echo "... done!"
