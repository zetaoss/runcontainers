# runcontainers

## Release

`tags.yaml` lists the published tag of each image (`<lang>: <YYYY-MM-DD>`, UTC). The latest date in the
file is the release: to release, change Dockerfiles in `img/` and set those images to today's date.

- On merge to main, images at the release date whose tag is not in the registry yet are built and pushed
  as `ghcr.io/zetaoss/runcontainers/<lang>:<tag>` and `:latest` (`latex` also as `tex`).
- Earlier entries are already published and are not touched. Tags are never rebuilt, so old tags stay
  available for rollback.
- Pull requests build the release and fail if a changed `img/Dockerfile.<lang>` is not in it.

bob keeps a copy of `tags.yaml` and runs these tags; copy it there and release bob to use new images.
