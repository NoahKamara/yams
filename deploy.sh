#!/bin/bash

#
# This script is used to deploy yams to the server

function check_file() {
    if [ ! -f "$1" ]; then
        echo "$1 not found, please create it"
        exit 1
    fi
}

check_file "docker-compose.yml"
check_file ".env"
check_file "configarr/config.yml"
check_file "configarr/secrets.yml"

# Set the source directory (default to current directory)
SRC_DIR="."
DEST_DIR="."

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --src)
      SRC_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    --dest)
      DEST_DIR="$2"
      shift
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# After parsing command line arguments, check if DEST_DIR is still '.'
if [ "$DEST_DIR" = "." ]; then
  echo "Error: No destination directory specified. Use --dest <destination_dir> to specify the destination."
  exit 1
fi

# List of files to copy (source relative to SRC_DIR, destination is DEST_DIR)
FILES_TO_COPY=(
    "docker-compose.yml"
    ".env"
)

# List of directories to copy (source relative to SRC_DIR, destination relative to DEST_DIR)
# Format: "source_dir destination_dir"
DIRS_TO_COPY=(
    "configarr config/configarr/config"
)

# Copy files
for file in "${FILES_TO_COPY[@]}"; do
    echo "Copying $SRC_DIR/$file to $DEST_DIR/$file"
    cp "$SRC_DIR/$file" "$DEST_DIR/$file"
done

# Copy directories
for dir_pair in "${DIRS_TO_COPY[@]}"; do
    src_dir=$(echo $dir_pair | awk '{print $1}')
    dest_dir=$(echo $dir_pair | awk '{print $2}')
    echo "Copying $SRC_DIR/$src_dir/* to $DEST_DIR/$dest_dir/"
    mkdir -p "$DEST_DIR/$dest_dir"
    cp -r "$SRC_DIR/$src_dir"/* "$DEST_DIR/$dest_dir/"
done
