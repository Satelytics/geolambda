#!/bin/bash

VERSION=$(cat VERSION)
PYVERSION=$(cat python/PYVERSION)

docker build . -t satelytics/geolambda:${VERSION}
docker run --rm -v $PWD:/home/geolambda -it satelytics/geolambda:${VERSION} package.sh

cd python
docker build . --build-arg VERSION=${VERSION}   -t satelytics/geolambda:${VERSION}-python
docker run -v ${PWD}:/home/geolambda -t satelytics/geolambda:${VERSION}-python package-python.sh

#docker run -e GDAL_DATA=/opt/share/gdal -e PROJ_LIB=/opt/share/proj \
#    --rm -v ${PWD}/lambda:/var/task lambci/lambda:python3.7 lambda_function.lambda_handler '{}'
