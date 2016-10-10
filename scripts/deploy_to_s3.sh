#!/usr/bin/env bash
set -eux
readonly PROGNAME=${0##*/}

abort () {
    echo "$@" 1>&2
    exit 1
}

REVISION=$(git rev-parse --short HEAD)


rm -rf public
mkdir public
cp -r doc/_build/html/* public

chmod -R 777 ./public

S3PATH="juliadocja/${TRAVIS_PULL_REQUEST}"

echo "going to build artifact to http://${S3PATH}"

aws s3 sync ./public s3://${S3PATH}
