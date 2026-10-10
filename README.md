# runcontainers

## Release

`VERSION` holds the repository version (`0.x.y`, semver), and every image is published at it. To release,
bump `VERSION` in a pull request; merging it runs the `release` workflow, which creates the `v<VERSION>` tag
and GitHub release. Merges that leave `VERSION` alone go out with the next release.

- patch: images change, but not as users see them (rebuild for security updates, base patch version, build fix).
- minor: a change users see (language or base major/minor version, packages or data added or removed,
  a new language). Breaking changes are minor while in 0.x.
- No release when no image changes (CI, README, `tests/` only).

The `release` workflow builds the images whose `img/Dockerfile.<lang>` or `tests/Dockerfile.<lang>` changed
since the previous release and pushes them as `ghcr.io/zetaoss/runcontainers/<lang>:<version>`
(`latex` also as `tex`), with build provenance (`gh attestation verify oci://<image> -R zetaoss/runcontainers`).
Unchanged images get the new version tag on the same digest (no rebuild), so every release has all images:
run `ghcr.io/zetaoss/runcontainers/<lang>:v<VERSION>`. When the release succeeds, `latest` of every image moves to
it. Version tags are never deleted: an unchanged image's tag may share its manifest with earlier versions. Put `[rebuild]` in the pull request title to rebuild
every image (e.g. for security updates). bob keeps the runcontainers version; set it there and release bob to
use new images.

## Tests

If `tests/Dockerfile.<lang>` exists, it is built `FROM` the new image (`--build-arg IMAGE=...`) in pull requests
and before the push in a release; a failing `RUN` fails the build. Add a test when you change an image.
Pull requests build and test the changed images (every image when `.github/` changes).

## Base images

Each `img/Dockerfile.<lang>` names its base image with a version tag in `FROM` (no build args), so a local
`docker build` gives the same image as CI. Dependabot opens one weekly PR (`base-images`) that bumps these
tags; merge it (with fixes and tests as needed) to include them in the next release, or close it to skip.
`texlive/texlive:latest-small` has no versioned small tag and follows the current TeX Live.
