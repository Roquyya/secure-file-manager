#!/bin/bash

# ===============================================
# Part 2: The Basic Organizer Script
# ===============================================

# --- 1. Define Source and Destination Directories ---
SOURCE_DIR="source_files"
DEST_DIR="organized_files"

echo "Starting file organization from $SOURCE_DIR to $DEST_DIR..."

# --- 2. Loop Through All Files in Source Directory ---
# The * ensures we only loop over files/directories inside SOURCE_DIR
for FILE in "$SOURCE_DIR"/*; do
    # Skip if it's a directory (optional, but good practice)
    if [ -d "$FILE" ]; then
        continue
    fi

    # Extract the file name (basename) and extension
    FILENAME=$(basename "$FILE")
    # Get the part after the last dot (the extension) and convert to lowercase
    EXTENSION="${FILENAME##*.}"
    EXTENSION_LOWER=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

    # Default subdirectory
    SUBDIR="other"

    # --- 3. Use a Case Statement to Determine Subdirectory ---
    case "$EXTENSION_LOWER" in
        jpg|jpeg|png|gif)
            SUBDIR="images"
            ;;
        txt|md)
            SUBDIR="documents"
            ;;
        sh)
            SUBDIR="scripts"
            ;;
        log)
            SUBDIR="logs"
            ;;
        *)
            # If extension is not matched, it defaults to "other"
            ;;
    esac

    # Define the final destination path
    DEST_SUBDIR="$DEST_DIR/$SUBDIR"

    # --- 4. Create Subdirectory if it Doesn't Exist ---
    # The -p flag ensures the directory is created if it doesn't exist.
    mkdir -p "$DEST_SUBDIR"

    # --- 5. Move the file ---
    echo "Moving $FILENAME to $DEST_SUBDIR"
    mv "$FILE" "$DEST_SUBDIR/"
done

echo "Organization complete."

