#!/bin/sh

REGISTRY=$1
version=$2
if [ -z "$version" ]; then
	echo "no version specified"
	version="latest"
fi
echo Building and publishing cross platform "$REGISTRY"rosbase:latest
docker run --privileged tonistiigi/binfmt --install amd64,arm64
if [ -f "/tmp/buildkit-config.tom" ]; then
  docker buildx create --use --config /tmp/buildkit-config.tom --driver-opt network=host --name impbuildx
else
  docker buildx create --use --name impbuildx
fi

docker buildx build --platform linux/amd64,linux/arm64 -t "$REGISTRY"rosbase:latest -f ./build/docker/Dockerfile-base . --push

packages=$(ls src/ros/workspace)
for package in $packages; do
  echo "Building and pushing cross/platform $package"
  cd src/ros/workspace || exit
  docker buildx build --platform linux/amd64,linux/arm64 -t "$REGISTRY$package:$version" --build-arg REGISTRY="$REGISTRY" --build-arg PACKAGE="$package" -f ../../../build/docker/Dockerfile-build . --push
  cd ../../../ || exit
done
