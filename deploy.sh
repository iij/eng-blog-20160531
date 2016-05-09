#!/bin/bash

set -ex

cd build

git config --global user.name "Travis CI"
git config --global user.email "nobody@nobody.org"

git init
git add .
git commit -m "Deploy to Github Pages"
git push --force --quiet "https://${GH_TOKEN}@${GH_REPO}" master:gh-pages > /dev/null 2>&1
