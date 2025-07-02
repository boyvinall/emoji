#!/bin/bash
# Regenerate the emoji list in the readme from the source directory
# preserve the existing readme content except for the emoji list separated by "---"

SOURCE_DIR="images"
README_FILE="README.md"
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

# Extract the existing content before the emoji list
awk '/^---$/ {exit} {print}' "$README_FILE" > "$TEMP_FILE"
echo -e "---\n" >> "$TEMP_FILE"
echo "<table>" >> "$TEMP_FILE"
for f in images/*; do
  if [[ -f "$f" ]]; then
    # Extract the filename without extension
    name=$(basename "${f%.*}")
    # Append the emoji markdown to the temp file
    echo -e "<tr><td><code>:$name:</code></td><td><img src=\"$f\" width=\"32px\"></td></tr>" >> "$TEMP_FILE"
  fi
done
echo "</table>" >> "$TEMP_FILE"

mv "$TEMP_FILE" "$README_FILE"