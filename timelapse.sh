#!/bin/bash
##################################################################
# Author: Carsten Subbe 20150924                                 #
# Description: Take all jpg Files within the actual directory    #
# and create a avi video file. The images can be rotated before  #
# video creation.                                                #
# Dependencies: convert is part of the imagemagick package       #
#               avconv has replaced ffmpeg nowadays              #
#               sudo apt-get install imagemagick libav-tools     #
##################################################################

while getopts ":r:f:o:d" OPT
do
  case "$OPT" in
    r ) rot=$OPTARG;;
    f ) fps=$OPTARG;;
    o ) filename=$OPTARG;;
    \? ) help="1";;
  esac
done

if [ "$help" == "1" -o "$#" == "0" ]
then
  echo ""
  echo "Create a timelapse video of all jpg files in this directory"
  echo "Usage: createtimelapse.sh [-h|-help] [-r 90|180|270] [-f fps] -o filename"
  echo "-h|-help      : print this help"
  echo "-r 90|180|270 : rotate images 90, 180 or 270 degrees"
  echo "-f fps        : frames per second, range from 15-30 is usefull, default=20"
  echo "-o filename   : name of the video file without extension"
  echo "The original files will be copied to subfolder original/ before conversion."
  echo ""
  exit 1
fi

mkdir original
if [ "$rot" != "" ]
then
  echo "Rotate all images $rot degree clockwise. Please be patient."
  for file in `ls *.[jJ][pP][gG]`
  do
    cp $file original/
    convert -rotate $rot $file $file
  done
fi

echo "Now we are preparing the files."
i=0
for file in `ls *.[jJ][pP][gG]`
do
  ln -s $file $(printf "%04d.jpg" $i)
  i=$((i+1));
done

if [ "$fps" != "" ]
then
  avconv -f image2 -r $fps -i ./%04d.jpg -c copy $filename.avi
else
  avconv -f image2 -r 20 -i ./%04d.jpg -c copy $filename.avi
fi
echo "$filename has been created"
find . -type l -name \*.jpg -exec unlink {} \;

rm *.[jJ][pP][gG]
                            

