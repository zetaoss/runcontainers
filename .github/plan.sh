#!/usr/bin/env bash
# Prints, as a JSON matrix, the tags.yaml entries (<lang>: <YYYY-MM-DD>, KST) whose tag is not in the
# registry yet; those are built and pushed. With BASE=<git ref> (pull requests) it also checks that
# new tags are today and that every changed img/Dockerfile.<lang> comes with a new tag.
set -euo pipefail
registry=ghcr.io/zetaoss/runcontainers
today=$(TZ=Asia/Seoul date +%F)
changed=()
if [[ -n "${BASE:-}" ]]; then
  mapfile -t changed < <(git diff --name-only "$BASE"...HEAD -- 'img/Dockerfile.*' | sed 's|^img/Dockerfile\.||')
fi
items=()
failed=0
for lang in $(yq -r 'keys | .[]' tags.yaml); do
  tag=$(yq -r ".\"$lang\"" tags.yaml)
  if [[ ! "$tag" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "error $lang: tag must be YYYY-MM-DD, got $tag" >&2; failed=1; continue
  fi
  if [[ ! -f "img/Dockerfile.$lang" ]]; then
    echo "error $lang: no img/Dockerfile.$lang" >&2; failed=1; continue
  fi
  if docker buildx imagetools inspect "$registry/$lang:$tag" >/dev/null 2>&1; then
    if [[ " ${changed[*]-} " == *" $lang "* ]]; then
      echo "error $lang: img/Dockerfile.$lang changed but $tag is already released; set today's date ($today) or release tomorrow" >&2
      failed=1
    else
      echo "skip  $lang:$tag (exists)" >&2
    fi
    continue
  fi
  if [[ -n "${BASE:-}" && "$tag" != "$today" ]]; then
    echo "error $lang: new tag $tag is not today ($today)" >&2; failed=1; continue
  fi
  echo "build $lang:$tag" >&2
  items+=("{\"lang\":\"$lang\",\"tag\":\"$tag\"}")
done
[[ $failed == 0 ]] || exit 1
echo "[$(IFS=,; echo "${items[*]-}")]"
