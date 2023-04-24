# TDP Hue Notes

The version 4.10.0-0.0 of Hue is based on the 4.10.0 tag of the Cloudera repository.

## Build a Hue release with TDP version

You must first build the container that will build the release with:

```bash
docker build . -t tdp-hue-builder
```

Then, you can execute the build container with the following arguments:

```bash
docker run --rm -v "$(pwd)/..:/hue" -v "$(pwd)/target:/opt/tdp" tdp-hue-builder
```

The entrypoint takes a git tag as an additional arguments, that defaults to: release-4.10.0-0.0

Example on how to use it:

```bash
docker run --rm -v "$(pwd)/..:/hue" -v "$(pwd)/target:/opt/tdp" tdp-hue-builder release-4.10.0-0.0
```

This command generates a `tar.gz` file of the release at tdp/target/hue-release-4.10.0-0.0.tar.gz
