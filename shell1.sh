#!/bin/bash
# ============================================================
# Script Name : backup_directory.sh
# Purpose     : Copy a specified directory into a backup folder
#               with a timestamp in its name.
# Author      : Apurvam Arya
# Date        : 2025-11-20
# Usage       : ./backup_directory.sh <source_directory> <backup_root_directory>
# Example     : ./backup_directory.sh ~/projects ~/backups
# ============================================================

# Exit immediately if a command exits with a non-zero status
set -e

# ----------- Input Validation --------------------------------

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_root_directory>"
    exit 1
fi

# Assign meaningful variable names
SOURCE_DIR="$1"
BACKUP_ROOT_DIR="$2"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create backup root directory if it doesn't exist
mkdir -p "$BACKUP_ROOT_DIR"

# ----------- Backup Creation ---------------------------------

# Generate a timestamp like 2025-11-20_17-30-45
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"

# Use the base name of the source directory for backup folder name
SOURCE_BASENAME="$(basename "$SOURCE_DIR")"

# Full path of the new backup directory
BACKUP_DIR="$BACKUP_ROOT_DIR/${SOURCE_BASENAME}_backup_$TIMESTAMP"

# Create the backup directory
mkdir -p "$BACKUP_DIR"

# Copy the contents of the source directory to the backup directory
# -a preserves permissions, ownership, timestamps, and symbolic links
cp -a "$SOURCE_DIR"/. "$BACKUP_DIR"/

echo "Backup completed successfully!"
echo "Source : $SOURCE_DIR"
echo "Backup : $BACKUP_DIR"
