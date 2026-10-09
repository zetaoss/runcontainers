#!/usr/bin/env bash
# Makes the registry match tags.yaml (<lang>: <YYYY-MM-DD>[.N], dates in KST).
# For each entry whose tag is not in the registry yet:
#   - tag is today          -> build: printed on stdout as a JSON matrix for the build job
#   - tag is an earlier day -> latest is tagged with it, only if latest was created that day
#                              (with RETAG=1; otherwise only checked). Any other case fails.
set -euo pipefail
registry=ghcr.io/zetaoss/runcontainers
today=$(TZ=Asia/Seoul date +%F)
items=()
failed=0
for lang in $(yq -r 'keys | .[]' tags.yaml); do
  tag=$(yq -r ".\"$lang\"" tags.yaml)
  if [[ ! "$tag" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})(\.[0-9]+)?$ ]]; then
    echo "error $lang: invalid tag $tag" >&2; failed=1; continue
  fi
  day=${BASH_REMATCH[1]}
  if [[ ! -f "img/Dockerfile.$lang" ]]; then
    echo "error $lang: no img/Dockerfile.$lang" >&2; failed=1; continue
  fi
  if docker buildx imagetools inspect "$registry/$lang:$tag" >/dev/null 2>&1; then
    echo "skip  $lang:$tag (exists)" >&2
  elif [[ "$day" == "$today" ]]; then
    echo "build $lang:$tag" >&2
    items+=("{\"lang\":\"$lang\",\"tag\":\"$tag\"}")
  else
    created=$(docker buildx imagetools inspect "$registry/$lang:latest" --format '{{json .Image}}' |
      jq -r 'if has("created") then .created else .["linux/amd64"].created end')
    created_day=$(TZ=Asia/Seoul date -d "$created" +%F)
    if [[ "$created_day" != "$day" ]]; then
      echo "error $lang:$tag: not today ($today) and latest was created on $created_day" >&2; failed=1
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
