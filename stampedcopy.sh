#!/bin/sh

die() {
    case $1 in
        --no-exit)
            shift
            printf "%s\n" "$*" >&2
            ;;
        *)
            printf "%s\n" "$*" >&2
            exit 1
            ;;
    esac
}


stampedcopy() {
  [ -d "$1" ] || die "[ERROR] $(date): ${1} dosen't exit."


  [ -d "$2" ] || {
    die --no-exit "[WARN] $(date): ${2} dosen't exit."
    mkdir --verbose "$2"
  }

  readonly TIMESTAMP=$(date "+%F")
  for item in "$1"/*; do
    [ -e "$item" ] || continue
    file=$(basename $item)
    new_file="${2}/${TIMESTAMP}_${file}"
    cp "$item" "$new_file" --verbose
  done
}

stampedcopy $1 $2

