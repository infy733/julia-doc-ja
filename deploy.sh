#!/usr/bin/env bash
set -eux
readonly PROGNAME=${0##*/}

abort () {
    echo "$@" 1>&2
    exit 1
}

REVISION=$(git rev-parse --short HEAD)

[ "$TRAVIS_BRANCH" == "master" ] || exit 0
[ "$TRAVIS_PULL_REQUEST" == "false" ] || exit 0

rm -rf public
mkdir public
cp -r doc/_build/html/* public

cd public

chmod -R 777 ./*


git config --global user.name "Travis CI"
git config --global user.email "$GIT_AUTHOR_EMAIL"

git init
touch .nojekyll
git add .
git commit -m "ci: publish pages at ${REVISION}"
echo "pushing to gh-pages."
git push --force --quiet https://${GH_TOKEN}@github.com/naist-cl-parsing/julia-doc-ja.git master:gh-pages


