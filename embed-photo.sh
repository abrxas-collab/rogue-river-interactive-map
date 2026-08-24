#!/bin/bash
# Convert an image into the img:"data:..." snippet used by BUSINESSES entries.
# Usage: ./embed-photo.sh "Some-Business-RR.jpg"

set -e

if [ -z "$1" ]; then
  echo "Usage: ./embed-photo.sh \"filename.jpg\""
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "Can't find a file named: $1"
  echo "Make sure it's in this folder and the name matches exactly."
  exit 1
fi

case "${1##*.}" in
  jpg|jpeg|JPG|JPEG) mime="image/jpeg" ;;
  png|PNG)           mime="image/png"  ;;
  *) echo "Only .jpg and .png are supported (got: ${1##*.})"; exit 1 ;;
esac

kb=$(( $(wc -c < "$1") / 1024 ))
if [ "$kb" -gt 300 ]; then
  echo "⚠️  Heads up: $1 is ${kb}KB — that's large." >&2
  echo "   Consider shrinking it first (Preview → Tools → Adjust Size → 800px wide)." >&2
  echo >&2
fi

echo "Copy everything below this line into the business entry:"
echo "---------------------------------------------------------"
printf 'img:"data:%s;base64,%s"\n' "$mime" "$(base64 -i "$1")"
