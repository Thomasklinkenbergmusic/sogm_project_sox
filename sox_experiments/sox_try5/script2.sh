#! /bin/bash
# Script by Thomas Klinkenberg (2016)
#-------------------------------------------------------------------------------

INDIR=$1

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
