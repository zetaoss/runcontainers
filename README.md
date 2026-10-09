# runcontainers

## Release

`tags.yaml` lists the published tag of each image (`<lang>: <YYYY-MM-DD>[.N]`, dates in KST), and CI
keeps the registry matching it. To release an image, change its Dockerfile in `img/` and set its tag to
today's date (`<date>.N` for another release the same day).

For each entry whose tag is not in the registry yet:

- tag is today: build and push `ghcr.io/zetaoss/runcontainers/<lang>:<tag>` and `:latest` (`latex` also as `tex`).
- tag is an earlier day: tag the current `latest` with it, only if `latest` was created that day; otherwise CI fails.

Existing tags are never rebuilt, so old tags stay available for rollback. Pull requests build and check;
pushes and tags happen on merge to main. bob keeps a copy of `tags.yaml` and runs these tags; copy it
there and release bob to use new images.
