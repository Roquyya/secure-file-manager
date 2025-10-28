
#!/bin/bash

# ===============================================
# Part 3: Applying Secure Permissions
# ===============================================

# --- 1. Define Source, Destination, and Optional Group ---
SOURCE_DIR="source_files"
DEST_DIR="organized_files"
NEW_GROUP="$1" # Capture the first command-line argument as the new group

echo "Starting secure file organization from $SOURCE_DIR to $DEST_DIR..."

# Check if a group argument was provided
if [ -n "$NEW_GROUP" ]; then
    echo "Files and directories will be assigned to the group: $NEW_GROUP"
else
    echo "No group specified. Files will retain their current group ownership."
fi

# --- 2. Loop Through All Files in Source Directory ---
for FILE in "$SOURCE_DIR"/*; do
    # Skip if it's a directory
    if [ -d "$FILE" ]; then
        continue
    fi

    # Extract necessary file information
    FILENAME=$(basename "$FILE")
    EXTENSION="${FILENAME##*.}"
    EXTENSION_LOWER=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

    # Variables to hold the destination subdirectory and the file's permission
    SUBDIR="other"
    FILE_PERM="" # Default permission (will be set in the case statement)

    # --- 3. Determine Subdirectory and File Permissions ---
    case "$EXTENSION_LOWER" in
        jpg|jpeg|png|gif)
            SUBDIR="images"
            FILE_PERM="640" # rw-r-----
            ;;
        txt|md)
            SUBDIR="documents"
            FILE_PERM="640" # rw-r-----
            ;;
        sh)
            SUBDIR="scripts"
            FILE_PERM="750" # rwxr-x---
            ;;
        log)
            SUBDIR="logs"
            FILE_PERM="600" # rw-------
            ;;
        *)
            # Default for unhandled file types
            SUBDIR="other"
            FILE_PERM="640" # rw-r----- (A sensible default for non-executable files)
            ;;
    esac

    # Define the final destination path
    DEST_SUBDIR="$DEST_DIR/$SUBDIR"

    # --- 4. Create and Secure the Subdirectory ---
    if [ ! -d "$DEST_SUBDIR" ]; then
        echo "Creating secure directory: $DEST_SUBDIR"
        mkdir -p "$DEST_SUBDIR"
        # Apply Directory Permission Policy: 750
        chmod 750 "$DEST_SUBDIR"
        
        # Apply Group Ownership to Directory (Optional Bonus)
        if [ -n "$NEW_GROUP" ]; then
            chown :"$NEW_GROUP" "$DEST_SUBDIR"
        fi
    fi

    # --- 5. Move the file ---
    echo "Moving $FILENAME to $DEST_SUBDIR"
    mv "$FILE" "$DEST_SUBDIR/"

    # --- 6. Apply File Permission Policy ---
    FINAL_PATH="$DEST_SUBDIR/$FILENAME"
    echo "Setting permissions for $FILENAME to $FILE_PERM"
    chmod "$FILE_PERM" "$FINAL_PATH"

    # --- 7. Apply Group Ownership to File (Optional Bonus) ---
    if [ -n "$NEW_GROUP" ]; then
        chown :"$NEW_GROUP" "$FINAL_PATH"
    fi

done

echo "Secure organization complete."