#!/bin/bash

# jpeg images
jpegoptim -m 80 *.JPG

# mp4 videos
ffmpeg -i input.mp4  -vcodec libx264 -crf 28 output.mp4

