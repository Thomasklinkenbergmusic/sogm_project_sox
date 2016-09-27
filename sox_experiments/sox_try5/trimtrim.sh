#! /bin/bash
# Script by Thomas Klinkenberg (2016)
#-------------------------------------------------------------------------------
echo
echo "---Executing--- $0 "
echo
#-------------------------------------------------------------------------------

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

echo "Processing files..."
echo
