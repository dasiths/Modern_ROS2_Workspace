#!/bin/sh

version=$1
if [ -z "$version" ]; then
	echo "no version specified"
	version="latest"
fi
packages=$(ls src/ros/workspace)
for package in $packages; do
  echo "Building $package"
  cd src/ros/workspace || exit
  docker build -t "$package:$version" --build-arg PACKAGE="$package" -f ../docker/Dockerfile-build .
  cd .. || exit
done
