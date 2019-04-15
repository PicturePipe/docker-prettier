# Docker Image with Prettier

[![CircleCI Build](https://circleci.com/gh/PicturePipe/docker-prettier.svg?style=shield)](https://circleci.com/gh/PicturePipe/workflows/docker-prettier "CircleCI Build")
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovateapp.com/ "Renovate enabled")

[Docker](https://www.docker.com) image with [Prettier](https://prettier.io/)
preinstalled.

## Repository

The docker images are available in our [repository](https://quay.io/repository/picturepipe/prettier):

```console
docker pull quay.io/picturepipe/prettier
```

## Tags

The current released version is tagged `1.17.0`.

The latest development version is tagged as `latest`.

The releases will follow the upstream version, with an optional dash and number appended, if there
are multiple releases per upstream version.

So for example, the first release for upstream version `1.16.4` will be tagged `1.16.4`. If there
is a second release for this upstream version, it will be tagged `1.16.4-1`.

## Preparing a release

This project uses gitflow. To create a release, first start the release branch for the version
which you want to release:

```console
git flow release start 1.16.4
```

Perform any release related changes. At the very least, this means updating the current tag given in
`README.md`.

Now, publish the release:

```console
git flow release publish
```

This will push the branch to GitHub and trigger a run of CI. Once CI is complete and all tests have
passed, finish the release and push the tag to GitHub:

```console
git flow release finish --push --tag
```

## License

Distributed under the MIT license.

Copyright 2019 reelport GmbH
