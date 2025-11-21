#!/bin/bash
# ============================================================
# Script Name : download_file.sh
# Purpose     : Download a file from the internet using wget or
#               curl and store it in a predefined directory.
# Author      : Apurvam Arya
# Date        : 2025-11-20
# Usage       : ./download_file.sh <url>
# Example     : ./download_file.sh https://example.com/file.zip
# Requirements: wget OR curl must be installed.
# ============================================================

# Exit on error
set -e

# ----------- Configuration -----------------------------------

# Predefined directory where downloaded files will be stored
DOWNLOAD_DIR="$HOME/auto_downloads"

# Create the directory if it does not exist
mkdir -p "$DOWNLOAD_DIR"

# ----------- Input Validation --------------------------------

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

FILE_URL="$1"

# Check if wget or curl is available
if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_TOOL="wget"
elif command -v curl >/dev/null 2>&1; then
    DOWNLOAD_TOOL="curl"
else
    echo "Error: Neither 'wget' nor 'curl' is installed."
    exit 1
fi

# ----------- Download Logic ----------------------------------

echo "Using download directory: $DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

echo "Starting download from: $FILE_URL"

if [ "$DOWNLOAD_TOOL" = "wget" ]; then
    # -q: quiet, -O keeps original name automatically
    wget "$FILE_URL"
else
    # curl: -O saves with remote name
    curl -O "$FILE_URL"
fi

echo "Download completed!"
echo "Files are saved in: $DOWNLOAD_DIR"
