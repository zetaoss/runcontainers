#!/usr/bin/env bash
# Makes the registry match release.yaml (releaseDate and images.<lang>: <YYYY-MM-DD>, UTC).
# Prints, as a JSON matrix, the images to build: tag == releaseDate and not in the registry yet.
# An image with an earlier tag not in the registry yet gets it on latest if latest was created that
# day (with RETAG=1; otherwise only checked). With BASE=<git ref> (pull requests) it also checks that
# releaseDate is within the last 7 days and that every changed img/Dockerfile.<lang> is released.
set -euo pipefail
registry=ghcr.io/zetaoss/runcontainers
date_re='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
release=$(yq -r '.releaseDate' release.yaml)
[[ "$release" =~ $date_re ]] || { echo "error: releaseDate must be YYYY-MM-DD, got $release" >&2; exit 1; }
changed=()
if [[ -n "${BASE:-}" ]]; then
  today=$(date -u +%F)
  oldest=$(date -u -d "$today - 7 days" +%F)
  if [[ "$release" > "$today" || "$release" < "$oldest" ]]; then
    echo "error: releaseDate $release is not between $oldest and $today (UTC)" >&2; exit 1
  fi
  mapfile -t changed < <(git diff --name-only "$BASE"...HEAD -- 'img/Dockerfile.*' | sed 's|^img/Dockerfile\.||')
fi
items=()
failed=0
for lang in $(yq -r '.images | keys | .[]' release.yaml); do
  tag=$(yq -r ".images.\"$lang\"" release.yaml)
  if [[ ! "$tag" =~ $date_re ]]; then
    echo "error $lang: tag must be YYYY-MM-DD, got $tag" >&2; failed=1; continue
  fi
  if [[ ! -f "img/Dockerfile.$lang" ]]; then
    echo "error $lang: no img/Dockerfile.$lang" >&2; failed=1; continue
  fi
  exists=0
  docker buildx imagetools inspect "$registry/$lang:$tag" >/dev/null 2>&1 && exists=1
  if [[ " ${changed[*]-} " == *" $lang "* && ( "$tag" != "$release" || $exists == 1 ) ]]; then
    echo "error $lang: img/Dockerfile.$lang changed; set images.$lang to an unreleased releaseDate" >&2
    failed=1; continue
  fi
  if [[ $exists == 1 ]]; then
    echo "skip  $lang:$tag (exists)" >&2
  elif [[ "$tag" == "$release" ]]; then
    echo "build $lang:$tag" >&2
    items+=("{\"lang\":\"$lang\",\"tag\":\"$tag\"}")
  else
    created=$(docker buildx imagetools inspect "$registry/$lang:latest" --format '{{json .Image}}' |
      jq -r 'if has("created") then .created else .["linux/amd64"].created end')
    if [[ "$(date -u -d "$created" +%F)" != "$tag" ]]; then
      echo "error $lang:$tag: not releaseDate, and latest was created on $(date -u -d "$created" +%F)" >&2
      failed=1
    elif [[ "${RETAG:-}" == 1 ]]; then
      docker buildx imagetools create -t "$registry/$lang:$tag" "$registry/$lang:latest"
      echo "tag   $lang:$tag (from latest)" >&2
    else
      echo "tag   $lang:$tag (from latest, on merge)" >&2
    fi
  fi
done
[[ $failed == 0 ]] || exit 1
echo "[$(IFS=,; echo "${items[*]-}")]"
