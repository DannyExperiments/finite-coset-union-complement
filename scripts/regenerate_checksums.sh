#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir"

tmp_file="$(mktemp "${TMPDIR:-.}/kourovka-checksums.XXXXXX")"
trap 'rm -f "$tmp_file"' EXIT

find . -type f \
  ! -path './.git/*' \
  ! -path './formalization/.lake/*' \
  ! -name 'SHA256SUMS.txt' \
  -print0 \
  | LC_ALL=C sort -z \
  | while IFS= read -r -d '' rel_file; do
      shasum -a 256 "$rel_file"
    done \
  | sed 's#  \./#  #' > "$tmp_file"

mv "$tmp_file" SHA256SUMS.txt
trap - EXIT
echo "Regenerated SHA256SUMS.txt"
