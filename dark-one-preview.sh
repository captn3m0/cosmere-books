#!/bin/bash

mkdir -p darkone

rm "dark-one.cbz"

for i in $(seq 1 29); do
  OUTPUT_FILE=$(printf "%02d" $i)
  wget --no-clobber "https://cdn1.thr.com/sites/default/files/2020/06/dark_one_preview_-_publicity_-_embed_$i-_2020.jpg" -O "darkone/$OUTPUT_FILE.jpg";
done

# Cover should be at first
mv darkone/04.jpg darkone/00.jpg

wget "https://cdn1.thr.com/sites/default/files/2020/06/dark_one_preview_-_publicity_-_embed_16-_2020_0.jpg" -O darkone/16.jpg

zip "books/dark-one.cbz" darkone/*.jpg
