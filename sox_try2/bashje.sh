#! /bin/bash
# Script by Thomas Klinkenberg (2016)
#-------------------------------------------------------------------------------
echo
echo "---Executing--- $0 "
echo
#-------------------------------------------------------------------------------

INFILE=$1
OUTFILE=$2
LENGHTFLOAT=$(soxi -D $INFILE)
LENGHT=${LENGHTFLOAT%.*}
SETOFF1=$(((RANDOM%($LENGHT - 5))+1))
SETOFF2=$(((RANDOM%($LENGHT - 3))+1))
SETOFF3=$(((RANDOM%($LENGHT - 2))+1))
PAN1=$(((RANDOM%(18))+1))
PAN2=$(((RANDOM%(18))+1))

# echo "Setoff _file1 = $SETOFF1"
# echo "Setoff _file2 = $SETOFF2"
# echo "Setoff _file3 = $SETOFF3"
# echo "Pan1 = $PAN1"
# echo "Pan2 = $PAN2"
# echo

sox --norm=-6 $INFILE ${OUTFILE}_file1.wav trim $SETOFF1 5 fade 0.1 0 0.1

sox --norm=-6 $INFILE ${OUTFILE}_file2.wav trim $SETOFF2 3 lowpass 500 reverb 25 remix 1p-$PAN1 2p-$PAN2 2 fade 0.1 0 0.1

sox $INFILE ${OUTFILE}_file3.wav trim $SETOFF3 2 overdrive 20 20 overdrive 20 20 overdrive 20 20 gain -12 fade 0.1 0 0.1

echo "Done!"
echo "-----"
echo
#-------------------------------------------------------------------------------
