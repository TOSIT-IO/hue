#!/bin/sh

set -e

TAG=${1:-release-4.10.0-0.0}

git checkout $TAG
PREFIX=/opt/tdp make install
git checkout -

# Make install relocatable
cd /opt/tdp/hue
sh tools/relocatable.sh
rm -Rf node_modules/
cd -

# Creating release
mv /opt/tdp/hue /opt/tdp/hue-$TAG
tar cvzf /opt/tdp/hue-$TAG.tar.gz -C /opt/tdp hue-$TAG
