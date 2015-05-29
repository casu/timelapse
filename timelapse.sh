!#/bin/bash
##################################################################
# Author: Carsten Subbe 20150212                                 #
# Description: Take all jpg Files within the actual directory    #
# and create an avi video file. The images can be rotated before #
# video creation.                                                #
# Dependencies: convert is part of the imagemagick package       #
#               avconv has replaced ffmpeg nowadays              #
#               sudo apt-get install imagemagick libav-tools     #
##################################################################
echo "Create a timelapse video of all jpg files in this directory"
echo ""
echo "Do we have to rotate the source images?"
echo "[0] no rotation"
echo "[1] 90 degree"
echo "[2] 180 degree"
echo "[3] 270 degree"
read answer

case "$answer" in
1) for file in `ls *.[jJ][pP][gG]`
   do
     convert -rotate 90 $file $file
   done
   ;;
2) for file in `ls *.[jJ][pP][gG]`
   do
     convert -rotate 180 $file $file
   done
   ;;
3) for file in `ls *.[jJ][pP][gG]`
   do
     convert -rotate 270 $file $file
   done
   ;;
esac

echo "Now we are preparing the files."
i=0
for file in `ls *.[jJ][pP][gG]`
do 
  ln -s $file $(printf "%04d.jpg" $i)
  i=$((i+1));
done
 
echo "Please enter the name of the output file (without extension)."
read answer
avconv -f image2 -r 25 -i ./%04d.jpg -c copy $answer.avi
#avconv -f image2 -r 25 -i ./%04d.jpg -c copy -crf 20 $answer.avi
echo "$answer.avi has been created"
find . -type l -name \*.jpg -exec unlink {} \;

echo "Can we delete the jpg files (y/n)"
read answer
if [ "$answer" == "y" -o "$answer" == "Y" ]
then
  rm *.[jJ][pP][gG]
fi
