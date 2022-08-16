#!/bin/sh

version=$1
if [ -z "$version" ]; then
	echo "no version specified"
	version="latest"
fi
docker build -t rosbase -f ./build/docker/Dockerfile-base .
packages=$(ls src/ros/workspace)
for package in $packages; do
  echo "Building $package container"
  cd src/ros/workspace || exit
  echo "registry is $REGISTRY"
	docker build -t "$package-test:$version" --build-arg REGISTRY="$REGISTRY" --build-arg PACKAGE="$package" -f ../../../build/docker/Dockerfile-test .
  echo "Testing $package"
  mkdir -p "$package/test-results"

  # run and check for errors
  if ! docker run -t --rm --mount type=bind,source="$(pwd)"/"$package"/test-results,target=/test-results  "$package-test:$version" bash -c "cd ${package} && make test"; then
    >&2 echo "Tests for $package failed"
    return 1;
  fi

  echo "list test results for $package"
  ls "$package"/test-results
  cd ../../../ || exit
done
