#!/bin/bash

VERSION=$(cat VERSION)
PYVERSION=$(cat python/PYVERSION)
rm -rf lambda-deploy.zip
docker build . -t satelytics/geolambda:${VERSION}
docker run --rm -v $PWD:/home/geolambda -it satelytics/geolambda:${VERSION} package.sh
#
cd python
rm -rf lambda-deploy.zip
sudo rm -rf lambda/*
# added --no-cache so that new versions of packages will be included in layer when running script
docker build . --no-cache --build-arg VERSION=${VERSION}  --build-arg AWS_SECRET_ACCESS_KEY=$SECRET --build-arg AWS_ACCESS_KEY_ID=$KEY -t satelytics/geolambda:${VERSION}-python
docker run -v ${PWD}:/home/geolambda -t satelytics/geolambda:${VERSION}-python package-python.sh
#aws s3 cp python/lambda-deploy.zip s3://sioprocess
#aws lambda publish-layer-version --layer-name gdal_rio_ripp --content S3Bucket=sioprocess,S3Key=lambda-deploy.zip --region us-east-1 --compatible-runtimes python3.7 python3.8 python3.9
#aws s3 rm  s3://sioprocess/lambda-deploy.zip
#docker run -e GDAL_DATA=/opt/share/gdal -e PROJ_LIB=/opt/share/proj \
#    --rm -v ${PWD}/lambda:/var/task lambci/lambda:python3.7 lambda_function.lambda_handler '{}'

# No need to automatically publish until we standardize this
# aws lambda publish-layer-version --layer-name "geolambda_python_3.9.9" --description "Description of your layer" --zip-file fileb://path/to/your/layer.zip