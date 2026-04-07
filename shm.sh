#bin/sh

shm() {
  tempfile=$(mktemp)
  df | awk '{gsub(/%/, "", $5); if ($5 >= 80) print $0}' > "$tempfile"
  # 一行目とそれ以外の違いは、「81%」のようにパーセントを書き出すかどうかのみです。一行目ヘッダー部にはパーセントはいらないので表示しないようにしています。
  awk 'NR == 1 { printf "%10s %s\n", $1, $5; next } {printf "%10s %s%%\n", $1,$5}' "$tempfile"

  if [ -n "$1" ]; then
    awk '{ if ($5 >= "'"$1"'") exit 1 } END { exit 0 }' "$tempfile"
  fi
}

if [ "$#" -gt 3 ]; then
  printf "Usage: %s [Upper limit (percentage) for treating as an error]\n", "$0"
fi

shm "$1"

