#!/bin/sh

version=$1
if [ -z "$version" ]; then
	echo "no version specified"
	version="latest"
fi
docker build -t rosbase -f ./docker/Dockerfile-base .
packages=$(ls src/ros/workspace)
for package in $packages; do
  echo "Building $package container"
  cd src/ros/workspace || exit
	docker build -t "$package-test:$version" --build-arg PACKAGE="$package" -f ../docker/Dockerfile-test .
  echo "Testing $package"
  mkdir -p "$package/test-results"
  docker run -t --rm --mount type=bind,source="$(pwd)"/"$package"/test-results,target=/test-results  "$package-test:$version" bash -c "cd ${package} && make test"
  echo "list test results for $package"
  ls "$package"/test-results
  cd .. || exit
done
