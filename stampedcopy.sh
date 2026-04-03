#!/bin/sh
# stampedcopy.sh - Copy all regular files from a source directory to a
# destination directory, prefixing each filename with the current date (YYYY-MM-DD).

# die: Print an error message to stderr and exit with a non-zero status.
#   $* - The error message to display.
die() {
  printf "%s\n" "$*" >&2
  exit 1
}

# stampedcopy: Copy regular files from src to dst with a date-stamp prefix.
#   $1 - Source directory (must already exist).
#   $2 - Destination directory (created automatically if absent).
stampedcopy() {
  # Verify that the source directory exists before proceeding.
  [ -d "$1" ] || die "Source directory '${1}' doesn't exist."

  # Create the destination directory if it does not already exist.
  [ -d "$2" ] || {
    printf "Creating directory: %s\n" "$2"
    mkdir -p "$2" || die "Failed to create '$2'."
  }

  # Capture today's date once (ISO 8601: YYYY-MM-DD) to use as a filename prefix.
  readonly TIMESTAMP=$(date "+%F")

  # Iterate over every entry in the source directory.
  for path in "$1"/*; do
    # Skip non-regular files (directories, symlinks, etc.).
    [ -f "$path" ] || continue

    # Extract just the filename from the full path (e.g. "foo.txt").
    file=${path##*/}

    # Build the destination path with the timestamp prefix (e.g. "dst/2026-04-03_foo.txt").
    new_file="${2}/${TIMESTAMP}_${file}"

    # Copy the file; abort the whole operation if any copy fails.
    cp -- "$path" "$new_file" || die "Failed to copy '$path' to '$new_file'."
  done
}

# Require exactly two arguments: source and destination directories.
if [ $# -lt 2 ]; then
  printf "Usage: %s src dst\n" "$0"
  exit 1
fi

stampedcopy "$1" "$2"
