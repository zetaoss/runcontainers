# runcontainers

## Release

`tags.yaml` lists the published tag of each image (`<lang>: <YYYY-MM-DD>`, KST), and CI keeps the
registry matching it. To release an image, change its Dockerfile in `img/` and set its tag to today's
date. One release per image per day; a second change the same day waits for the next day.

- An entry whose tag is not in the registry yet is built and pushed as
  `ghcr.io/zetaoss/runcontainers/<lang>:<tag>` and `:latest` (`latex` also as `tex`) on merge to main.
- Existing tags are never rebuilt, so old tags stay available for rollback.
- Pull requests build those entries and fail if a new tag is not today or if `img/Dockerfile.<lang>`
  changed without a new tag.

bob keeps a copy of `tags.yaml` and runs these tags; copy it there and release bob to use new images.
