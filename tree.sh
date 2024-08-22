#!/bin/bash

# Name of the root directory
ROOT_DIR="/Users/rashedzaman/learning-arabic-alphabet"
# Output file
OUTPUT_FILE="tree.readme.md"

# Function to recursively list directories and files
generate_tree() {
    local current_dir=$1
    local indent=$2

    # List all items in the current directory
    for item in "$current_dir"/*; do
        if [ -d "$item" ]; then
            # If the item is a directory, print its name and recurse into it
            echo "${indent}├── $(basename "$item")/" >> "$OUTPUT_FILE"
            generate_tree "$item" "$indent│   "
        elif [ -f "$item" ]; then
            # If the item is a file, skip image, mp3, and mp4 files
            case "$(basename "$item")" in
                *.jpg|*.jpeg|*.png|*.gif|*.mp3|*.mp4)
                    continue
                    ;;
                *)
                    echo "${indent}├── $(basename "$item")" >> "$OUTPUT_FILE"
                    ;;
            esac
        fi
    done

    # Replace the last directory marker from '├──' to '└──'
    if [[ "$(find "$current_dir" -maxdepth 1 -type d | wc -l)" -gt 1 ]] || [[ "$(find "$current_dir" -maxdepth 1 -type f | wc -l)" -gt 0 ]]; then
        sed -i '$s/├──/└──/' "$OUTPUT_FILE"
    fi
}

# Start with a fresh output file
echo "- Directory Structure of $ROOT_DIR" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "$ROOT_DIR/" >> "$OUTPUT_FILE"

# Generate the tree structure starting from the root directory
generate_tree "$ROOT_DIR" ""

echo "Tree structure written to $OUTPUT_FILE"