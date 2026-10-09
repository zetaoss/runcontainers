# runcontainers

## Release

`release.yaml` lists the published tag of each image under `images` (dates in UTC), and CI keeps the
registry matching it. To release, change Dockerfiles in `img/`, set `releaseDate` to today, and set
those images' tags to `releaseDate`. One release per image per day.

On merge to main, for each image whose tag is not in the registry yet:

- tag is `releaseDate`: build and push `ghcr.io/zetaoss/runcontainers/<lang>:<tag>` and `:latest` (`latex` also as `tex`).
- earlier tag: tag the current `latest` with it, only if `latest` was created that day; otherwise CI fails.

Existing tags are never rebuilt, so old tags stay available for rollback. Pull requests build the
images to release and fail if `releaseDate` is not within the last 7 days or if a changed
`img/Dockerfile.<lang>` is not released with it.

bob keeps a copy of `release.yaml` and runs these tags; copy it there and release bob to use new images.
