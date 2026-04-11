#!/bin/sh

shm() {
  tempfile=$(mktemp)
  df | awk '{gsub(/%/, "", $5); if ($5 >= 80) print $0}' > "$tempfile"
  # line 5 filters out the original df header, so print a header explicitly here
  awk 'BEGIN { printf "%10s %s\n", "Filesystem", "Use%" } { printf "%10s %s%%\n", $1, $5 }' "$tempfile"

  if [ -n "$1" ]; then
    awk '{ if ($5 >= "'"$1"'") exit 1 } END { exit 0 }' "$tempfile"
  fi
}

if [ "$#" -gt 3 ]; then
  printf "Usage: %s [Upper limit (percentage) for treating as an error]\n", "$0"
fi

shm "$1"

