#!/bin/bash

for f in `find ./ -type f \( -iname \*.HEIC -o -iname \*.heic \)`
do
  fname=$(basename -- "$f")
  ext="${fname##*.}"
  file="${fname%.*}"
  echo "converting ${f}..."
  heif-convert ${f} ${file}.JPG
done


