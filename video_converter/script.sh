#!/bin/bash
bin=./bin
media_pool=./media_in
converted_tag=_converted # must also be manually changed in convert_command

# put all non video files recursively in bin folder
find $media_pool -type f \
  -exec bash -c 'file -b --mime-type "$0" | grep -qvE "^video/"' {} \; \
  -exec mv -t $bin {} +

#remove all empty folders
find $media_pool -type d -empty -delete

# convert all video without converted tag in filename
export FFREPORT=file=ffreport.log:level=24
convert_command='ffmpeg  -loglevel warning -hide_banner -i "$0" -c:v libx264 -crf 23 -c:a aac -strict experimental -b:a 192k "${0%.*}_converted.mp4" && rm "$0"'
find "$media_pool" -type f -not -iname "*${converted_tag}*" -exec bash -c "$convert_command" {} \;