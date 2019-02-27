#!/bin/bash

set -e
set -u
set -o pipefail

cd "$(dirname "$0")"

if [ -z "${CI:-}" ]; then
	DOCKER_IMAGE_SPEC="prettier"
else
	# When we are running on CircleCI, retrieve the image and tag which we just built.
	# This is a bit hacky, but we don't have access to the parameters passed to docker-publish/build.
	DOCKER_IMAGE_SPEC="$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "${DOCKER_IMAGE}:")"
fi

echo "==> Checking if prettier is present in the image..." >&2
if docker run --rm "$DOCKER_IMAGE_SPEC" prettier -v > /dev/null; then
	echo "==> prettier found." >&2
else
	echo "==> prettier seems to be broken!" >&2
	exit 1
fi

echo "==> Checking if git is present in the image..." >&2
if docker run --rm "$DOCKER_IMAGE_SPEC" git version | grep -q 'git version'; then
	echo "==> Git found." >&2
else
	echo "==> Git seems to be broken!" >&2
	exit 1
fi

docker volume rm prettier-test >/dev/null 2>&1 || true
docker volume create prettier-test > /dev/null
DOCKER_CMD=(docker run --rm -i -v prettier-test:/home/node/app "$DOCKER_IMAGE_SPEC")
tar c tests | "${DOCKER_CMD[@]}" tar x

echo "==> Checking if prettier complains about broken files as expected..." >&2
if "${DOCKER_CMD[@]}" prettier --check 'tests/**'; then
	echo "==> Prettier did not complain as expected!" >&2
	exit 1
else
	echo "==> Prettier complained as expected." >&2
fi

# We do not want to expand the following backticks
# shellcheck disable=SC2016
echo '==> Cleaning up files with `prettier --write`...' >&2
"${DOCKER_CMD[@]}" prettier --write 'tests/**'

echo "==> Checking if prettier has fixed the files..." >&2
if "${DOCKER_CMD[@]}" prettier --check 'tests/**'; then
	echo "==> Prettier seems to work alright." >&2
else
	echo "==> Prettier write did not behave as expected!" >&2
	exit 1
fi
