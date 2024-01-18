#!/bin/bash

# create a bin folder if it doesn't exist
mkdir -p $BIN
# put all non video files recursively in the bin folder
find $MEDIA_POOL -type f \
  -not -path "*/@eaDir/*" \
  -exec bash -c 'file -b --mime-type "$0" | grep -qvE "^video/"' {} \; \
  -exec mv -t $BIN {} +

#remove all empty folders
find $MEDIA_POOL -type d -empty -delete

# Convert all founded files. after end_hour, finish current conversion and exit
# Iterate over each file found by 'find' command
while IFS= read -r -d '' file; do
    # Check the current time
    current_hour=$(date +%H)
    
    # If the current time is beyond the end hour, exit the loop
    if [ "$current_hour" -ge "$END_TIME" ]; then
        echo "Stopping script as it's past $END_TIME:00."
        break
    fi

    # Skip files inside @eaDir directories
    if [[ "$file" == *"@eaDir"* ]]; then
        continue
    fi
    
    #Convert the file
    input="$file"
    output="${input%.*}_${CONVERTED_TAG}.mp4"
    ffmpeg -loglevel warning -hide_banner -i "$input" -c:v libx264 -crf 23 -c:a aac -strict experimental -b:a 192k "$output" && rm "$input"
done < <(find "$MEDIA_POOL" -type f -not -iname "*${CONVERTED_TAG}*" -print0)