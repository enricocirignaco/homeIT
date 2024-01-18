#!/bin/bash
bin=./bin
media_pool=./media
converted_tag=_converted # must also be manually changed in convert_command
end_hour=14

# put all non video files recursively in the bin folder
find $media_pool -type f \
  -exec bash -c 'file -b --mime-type "$0" | grep -qvE "^video/"' {} \; \
  -exec mv -t $bin {} +

#remove all empty folders
find $media_pool -type d -empty -delete

# Convert all founded files. after end_hour, finish current conversion and exit
# Iterate over each file found by 'find' command
while IFS= read -r -d '' file; do
    # Check the current time
    current_hour=$(date +%H)
    
    # If the current time is beyond the end hour, exit the loop
    if [ "$current_hour" -ge "$end_hour" ]; then
        echo "Stopping script as it's past $end_hour AM."
        break
    fi

    # Convert the file
    input="$file"
    output="${input%.*}_${converted_tag}.mp4"
    ffmpeg -loglevel warning -report -hide_banner -i "$input" -c:v libx264 -crf 23 -c:a aac -strict experimental -b:a 192k "$output" && rm "$input"
done < <(find "$media_pool" -type f -not -iname "*${converted_tag}*" -print0)