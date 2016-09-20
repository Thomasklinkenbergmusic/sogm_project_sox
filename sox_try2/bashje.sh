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
SETOFF4=$(((RANDOM%($LENGHT - 6))+1))
PAN1=$(((RANDOM%(18))+1))
PAN2=$(((RANDOM%(18))+1))


if [ -a ./output/ ]
then
  echo "Output File already exists!"
else
  mkdir output
  echo "Created output/ file!"
fi


# echo "Setoff _file1 = $SETOFF1"
# echo "Setoff _file2 = $SETOFF2"
# echo "Setoff _file3 = $SETOFF3"
# echo "Setoff _file4 = $SETOFF4"
# echo "Pan1 = $PAN1"
# echo "Pan2 = $PAN2"
# echo

# De comments hierboven kunnen alle waardes printen

sox $INFILE ./output/${OUTFILE}_file1.wav trim $SETOFF1 5 norm -6 fade 0.1 0 0.1
# Maakt een bestand van 5 seconde puur geluid

sox $INFILE ./output/${OUTFILE}_file2.wav trim $SETOFF2 3 lowpass 500 reverb 25 remix 1p-$PAN1 2p-$PAN2 2 norm -6 fade 0.1 0 0.1
# Maakt een bestand van 3 seconde met een lowpass, reverb en een (random) panning effect

sox $INFILE ./output/${OUTFILE}_file3.wav trim $SETOFF3 2 overdrive 20 20 overdrive 20 20 overdrive 20 20 norm -18 fade 0.1 0 0.1
# Maakt een bestand van 2 seconde met keiharde overdrive

sox $INFILE ./output/${OUTFILE}_file4.wav trim $SETOFF4 6 reverse fade 0.1 0 0.1 norm -6 fade 0.1 0 0.1
# Maakt een bestand van 6 seconde die volledig gereversed is

echo "Done!"
echo "-----"
echo

#-------------------------------------------------------------------------------
