#!/bin/sh

packages=$(ls src/ros/workspace)
for package in $packages; do
  echo "Building $package"
  make build-$package
done
