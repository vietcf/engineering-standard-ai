#!/usr/bin/env sh
# Export this project's Docker image to a .tar file.
# Usage: tools/docker-export.sh [version|latest] [out_dir]
#   version : release tag, e.g. 1.2.0 (default: latest = highest X.Y.Z tag found locally)
#   out_dir : output folder (default: <project>/dist)
# Image name = $IMAGE_NAME, or the project folder name (lowercase, spaces -> "-").
# Output: <out_dir>/<name>_<version>.tar
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${IMAGE_NAME:-$(basename "$ROOT" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')}"
SAFE="$(printf '%s' "$NAME" | tr '/:' '__')"
VERSION="${1:-latest}"
OUT_DIR="${2:-$ROOT/dist}"

# Print the highest X.Y.Z (optional "v" prefix) read from stdin
highest_version() {
  grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' |
    awk '{ v = $0; sub(/^v/, "", v); print v " " $0 }' |
    sort -t. -k1,1n -k2,2n -k3,3n | tail -n 1 | cut -d' ' -f2
}

if [ "$VERSION" = "latest" ]; then
  VERSION="$(docker images --filter dangling=false --format '{{.Tag}}' "$NAME" | highest_version)"
  if [ -z "$VERSION" ]; then
    echo "No release tag (X.Y.Z) found for image: $NAME" >&2
    exit 1
  fi
fi

IMAGE="$NAME:$VERSION"
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Image not found: $IMAGE" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
FILE="$OUT_DIR/${SAFE}_$VERSION.tar"

echo "Exporting $IMAGE -> $FILE"
docker save -o "$FILE" "$IMAGE"
echo "Done."
