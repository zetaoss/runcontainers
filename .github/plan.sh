#!/usr/bin/env bash
# Prints the matrix of tags.yaml entries whose image tag is not in the registry yet.
set -euo pipefail
registry=ghcr.io/zetaoss/runcontainers
items=()
for lang in $(yq -r 'keys | .[]' tags.yaml); do
  tag=$(yq -r ".\"$lang\"" tags.yaml)
  if [[ ! "$tag" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}(\.[0-9]+)?$ ]]; then
    echo "invalid tag for $lang: $tag" >&2; exit 1
  fi
  if [[ ! -f "img/Dockerfile.$lang" ]]; then
    echo "no img/Dockerfile.$lang" >&2; exit 1
  fi
  if docker buildx imagetools inspect "$registry/$lang:$tag" >/dev/null 2>&1; then
    echo "skip  $lang:$tag (exists)" >&2
  else
    echo "build $lang:$tag" >&2
    items+=("{\"lang\":\"$lang\",\"tag\":\"$tag\"}")
  fi
done
echo "[$(IFS=,; echo "${items[*]-}")]"
