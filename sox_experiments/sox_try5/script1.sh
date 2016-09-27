#! /bin/bash
#
# Marc Groenewegen © 2004
#
#-------------------------------------------------------------------------------
for f in *;
  do
  oldname=`echo $f |sed 's/ /~/g'`
  newname=`echo $f |sed 's/ /_/g'`
  if [ $oldname != $newname ]
  then
    # echo mv $f $newname
    mv "$f" $newname
  fi
done
