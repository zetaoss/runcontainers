# runcontainers

## Release

`tags.yaml` lists the published tag of each image (`<lang>: <YYYY-MM-DD>[.N]`). To release an image,
change its Dockerfile in `img/` and set its tag to today's date (or `<date>.N` for a second release that day).

- On a pull request, CI builds the entries whose tag is not in the registry yet.
- On merge to main, CI pushes them as `ghcr.io/zetaoss/runcontainers/<lang>:<tag>` and `:latest`
  (`latex` also as `tex`). Existing tags are never rebuilt, so old tags stay available for rollback.
- bob keeps a copy of `tags.yaml` and runs these tags; copy it there and release bob to use new images.
