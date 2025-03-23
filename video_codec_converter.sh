#!/bin/bash

# Example use:
#  ./check_video_codecs.sh <PATH>

# Check if a directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

echo "Scanning directory: $1"
directory="$1"
log_file="$directory/ffmpeg_conversion.log"
echo "Logging ffmpeg output to: $log_file"

# Store all MP4 files in an array
mapfile -d '' files < <(find "$directory" -type f -iname "*.mp4" -print0)

# Iterate over the array
for file in "${files[@]}"; do
    echo "Processing: $file"
    
    # Get codec information
    codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
    echo "Detected codec: $codec"
    
    # Convert only if H.265
    if [ "$codec" == "hevc" ]; then
        # Ask for confirmation before converting
        read -p "Convert $(basename "$file") from H.265 to H.264? (y/n): " confirm1 </dev/tty
        if [[ "$confirm1" =~ ^[Yy]$ ]]; then
            temp_file="${file%.mp4}_v2.mp4"
            echo "Converting H.265 to H.264: $(basename "$temp_file")"
            
            if ffmpeg -i "$file" -c:v libx264 -crf 18 -preset slow -c:a copy "$temp_file" &>> "$log_file"; then
                echo "Conversion completed: $(basename "$temp_file")"
                chown <USER>:<USER> $temp_file
                
                # Ask to replace the original file
                read -p "Replace file $(basename "$file") with re-encoded file $(basename "$temp_file")? (y/n): " confirm2 </dev/tty
                if [[ "$confirm2" =~ ^[Yy]$ ]]; then
                    mv "$temp_file" "$file"
                    echo "File replaced: $(basename "$file")"
                else
                    echo "Keeping both files."
                fi
            else
                echo "Conversion failed for: $(basename "$file"). Check log for details."
                rm -f "$temp_file"
            fi
        else
            echo "Skipping conversion for: $(basename "$file")"
        fi
    else
        echo "Skipping (not H.265): $(basename "$file")"
    fi
    echo "--------------------------------------"
done
