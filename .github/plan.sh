#!/usr/bin/env bash
# tags.yaml: <lang>: <YYYY-MM-DD> (UTC). The latest date in the file is the release.
# Prints, as a JSON matrix, the images at the release date whose tag is not in the registry yet.
# With BASE=<git ref> (pull requests) it also checks that every changed img/Dockerfile.<lang> is in the release.
set -euo pipefail
registry=ghcr.io/zetaoss/runcontainers
release=$(yq -r '[.[]] | sort | .[-1]' tags.yaml)
[[ "$release" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || { echo "error: invalid date $release" >&2; exit 1; }
failed=0
if [[ -n "${BASE:-}" ]]; then
  for lang in $(git diff --name-only "$BASE"...HEAD -- 'img/Dockerfile.*' | sed 's|^img/Dockerfile\.||'); do
    if [[ "$(yq -r ".\"$lang\"" tags.yaml)" != "$release" ]]; then
      echo "error $lang: img/Dockerfile.$lang changed; set $lang to $release or a new date" >&2; failed=1
    fi
  done
fi
items=()
for lang in $(yq -r "to_entries | .[] | select(.value == \"$release\") | .key" tags.yaml); do
  if [[ ! -f "img/Dockerfile.$lang" ]]; then
    echo "error $lang: no img/Dockerfile.$lang" >&2; failed=1
  elif docker buildx imagetools inspect "$registry/$lang:$release" >/dev/null 2>&1; then
    echo "skip  $lang:$release (exists)" >&2
  else
    echo "build $lang:$release" >&2
    items+=("{\"lang\":\"$lang\",\"tag\":\"$release\"}")
  fi
done
[[ $failed == 0 ]] || exit 1
echo "[$(IFS=,; echo "${items[*]-}")]"
