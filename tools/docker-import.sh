#!/usr/bin/env sh
# Load this project's Docker image from a .tar file.
# Usage: tools/docker-import.sh [version|latest] [dist_dir]
#   version  : release to load, e.g. 1.2.0 (default: latest = highest X.Y.Z file found)
#   dist_dir : folder with <name>_<version>.tar[.gz] files (default: <project>/dist)
# Image name = $IMAGE_NAME, or the project folder name (lowercase, spaces -> "-").
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${IMAGE_NAME:-$(basename "$ROOT" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')}"
SAFE="$(printf '%s' "$NAME" | tr '/:' '__')"
VERSION="${1:-latest}"
DIR="${2:-$ROOT/dist}"

# Print the highest X.Y.Z (optional "v" prefix) read from stdin
highest_version() {
  grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' |
    awk '{ v = $0; sub(/^v/, "", v); print v " " $0 }' |
    sort -t. -k1,1n -k2,2n -k3,3n | tail -n 1 | cut -d' ' -f2
}

if [ ! -d "$DIR" ]; then
  echo "Folder not found: $DIR" >&2
  exit 1
fi

if [ "$VERSION" = "latest" ]; then
  VERSION="$(ls "$DIR" | sed -n "s/^${SAFE}_\(.*\)\.tar\(\.gz\)\{0,1\}\$/\1/p" | highest_version)"
  if [ -z "$VERSION" ]; then
    echo "No release file (${SAFE}_X.Y.Z.tar) found in $DIR" >&2
    exit 1
  fi
fi

FILE=""
for f in "$DIR/${SAFE}_$VERSION.tar" "$DIR/${SAFE}_$VERSION.tar.gz"; do
  if [ -f "$f" ]; then FILE="$f"; break; fi
done

if [ -z "$FILE" ]; then
  echo "File not found: $DIR/${SAFE}_$VERSION.tar" >&2
  exit 1
fi

echo "Loading $FILE"
docker load -i "$FILE"
echo "Done."
