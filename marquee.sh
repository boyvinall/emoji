#!/bin/bash

# --- User-customizable variables ---
INPUT_IMAGE="$1"
OUTPUT_GIF="$2"
DELAY=5        # Delay between frames in 1/100ths of a second (e.g., 5 = 0.05s)

# --- Script Logic (do not edit below this line unless you want to customize) ---

# Get the original image dimensions
IMAGE_WIDTH=$(identify -format "%w" "$INPUT_IMAGE")
IMAGE_HEIGHT=$(identify -format "%h" "$INPUT_IMAGE")

if [ "$IMAGE_WIDTH" -le "$IMAGE_HEIGHT" ]; then
    echo "Error: Input image width must be greater than its height for a horizontal marquee."
    exit 1
fi

echo "Creating a temporary scrolling image strip..."
# Create a temporary image by appending the original image to itself.
# This creates a seamless loop for the marquee effect.
convert "$INPUT_IMAGE" +clone +append "temp_strip.png"

# Create a temporary directory for the animation frames
mkdir -p frames

echo "Generating frames for the GIF..."
# Loop from 0 to the width of the original image, generating a cropped frame for each pixel.
for i in $(seq 0 20 $((IMAGE_WIDTH - 1))); do
    # Crop a square section from the temp strip, shifting its position by 1 pixel each time.
    # The crop dimensions are square, with a width and height equal to the original image's height.
    convert "temp_strip.png" -crop "${IMAGE_HEIGHT}x${IMAGE_HEIGHT}+${i}+0" -size "${IMAGE_HEIGHT}x${IMAGE_HEIGHT}" -repage "${IMAGE_HEIGHT}x${IMAGE_HEIGHT}+0+0" -resize 64x64 "frames/frame_$(printf "%04d" "$i").png"
done

echo "Assembling the frames into an animated GIF..."
# Assemble the frames into the final GIF, applying the specified delay and looping infinitely.
convert -delay "$DELAY" -loop 0 frames/frame_*.png "$OUTPUT_GIF"

echo "Cleaning up temporary files..."
rm "temp_strip.png"
rm -rf frames

echo "Marquee GIF created successfully: $OUTPUT_GIF"