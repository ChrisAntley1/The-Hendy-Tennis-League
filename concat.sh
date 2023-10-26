#!/bin/bash

# Output file name for the concatenated video
output_file="output_concatenated.mp4"

# List all video files in the current directory and save them to a temporary file
find . -maxdepth 1 -type f -name "*.mp4" -exec echo "file '{}'" \; > input_files.txt

# Check if there are any video files
if [ -s "input_files.txt" ]; then
    # Concatenate the videos using FFmpeg
    ffmpeg -f concat -safe 0 -i input_files.txt -c:v libx264 -crf 23 -c:a aac -strict experimental "$output_file"
    echo "Concatenation successful. Output file: $output_file"
else
    echo "No video files found in the current directory."
fi

# Clean up temporary file
rm -f input_files.txt
