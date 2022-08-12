#!/bin/bash

nextReleaseVersion="$1"

RELEASE=${nextReleaseVersion} make ci-push-all registry="${REGISTRY}" version="${nextReleaseVersion}"
