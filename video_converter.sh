
paths=`find ../galleries/ -name *.MOV`
fname="zztest.jpg"
for p in $paths 
do
  echo $p
  #echo "mediainfo"
  #mediainfo --Full --Output=XML --Language=raw $p
  #echo "ffmpeg"
  #ffmpeg -ss 4 -i "$p" -vcodec mjpeg -vframes 1 -an -f rawvideo -y $fname
  ffmpeg -i $p ${p%.*}.mp4
  #rm $p
  #rm $fname
done
echo "done"


