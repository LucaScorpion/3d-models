#!/usr/bin/env bash
set -euo pipefail

# Loop over all .scad files and generate PNG previews
for scad in **/*.scad; do
    # Replace the .scad extension with .png
    output="${scad//.scad/}.png"

    echo "Rendering: $scad"
    openscad -o "$output" "$scad"
done
