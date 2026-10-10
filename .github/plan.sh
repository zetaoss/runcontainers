#!/usr/bin/env bash
# Prints, as a JSON array, the images (<lang> of img/Dockerfile.<lang>) to build:
# - ALL=1: every image.
# - otherwise: images whose img/Dockerfile.<lang> or tests/Dockerfile.<lang> changed since BASE (a git ref),
#   and, with PREV=<previous release tag>, images not published at it (new images).
set -euo pipefail
all=$(ls img/Dockerfile.* | sed 's|^img/Dockerfile\.||')
if [[ "${ALL:-}" == 1 ]]; then
  langs=$all
else
  langs=$(git diff --name-only "$BASE"...HEAD -- img tests | sed -n 's#^\(img\|tests\)/Dockerfile\.##p')
  if [[ -n "${PREV:-}" ]]; then
    for lang in $all; do
      docker buildx imagetools inspect "ghcr.io/zetaoss/runcontainers/$lang:$PREV" >/dev/null 2>&1 || langs+=$'\n'$lang
    done
  fi
fi
for lang in $langs; do [[ -f "img/Dockerfile.$lang" ]] && echo "$lang"; done | sort -u | jq -Rsc 'split("\n") | map(select(. != ""))'
