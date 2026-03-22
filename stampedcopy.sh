#!/bin/sh

die() {
  printf "%s\n" "$*" >&2
  exit 1
}


stampedcopy() {
  [ -d "$1" ] || die "Source directory '${1}' doesn't exist."


  [ -d "$2" ] || {
    printf "Creating directory: %s\n" "$2"
    mkdir -p "$2" || die "Failed to create '$2'."
  }

  readonly TIMESTAMP=$(date "+%F")
  for path in "$1"/*; do
    [ -e "$path" ] || continue
    file=${path##*/}
    new_file="${2}/${TIMESTAMP}_${file}"
    cp "$path" "$new_file"
  done
}

if [ $# -lt 2 ]; then
  printf "Usage: %s src dst\n" "$0"
  exit 1
fi

stampedcopy "$1" "$2"

