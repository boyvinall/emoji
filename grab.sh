#!/bin/bash
# Take a URL like https://emoji.slack-edge.com/T016WLPF0G6/powerup/3f96147ec05f480f.gif
# and download the file, saving it as powerup.gif

URL=$1
if [ -z "$URL" ]; then
  echo "Usage: $0 <url>"
  exit 1
fi

FILENAME=$2

# Extract the filename from the URL
d=$(dirname "$URL")
f=$(basename "$d")
ext="${URL##*.}"

if [ -z "$FILENAME" ]; then
  FILENAME="$f"
fi

# replace underscore with dash
FILENAME="${FILENAME//_/-}"

curl -o "images/$FILENAME.$ext" "$URL"
