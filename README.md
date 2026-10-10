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

## Base images

Each `img/Dockerfile.<lang>` names its base image with a version tag in `FROM` (no build args), so a local
`docker build` gives the same image as CI. Dependabot opens one weekly PR (`base-images`) that bumps these
tags; set the changed images to the release date in `tags.yaml` to release them, or close the PR to skip.
`texlive/texlive:latest-small` has no versioned small tag and follows the current TeX Live.
