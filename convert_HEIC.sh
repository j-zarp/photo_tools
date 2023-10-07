#!/bin/bash

for f in *.HEIC
do
  fname=$(basename -- "$f")
  ext="${fname##*.}"
  file="${fname%.*}"
  echo "converting ${f}..."
  heif-convert ${f} ${file}.JPG
done


