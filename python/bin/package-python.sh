#!/bin/bash

# directory used for development
export DEPLOY_DIR=lambda

# make deployment directory and add lambda handler
mkdir -p $DEPLOY_DIR/lib

# copy libs
cp -P ${PREFIX}/lib/*.so* $DEPLOY_DIR/lib/
cp -P ${PREFIX}/lib64/libjpeg*.so* $DEPLOY_DIR/lib/

strip $DEPLOY_DIR/lib/* || true

# copy GDAL_DATA files over
#mkdir -p $DEPLOY_DIR/share
#rsync -ax $PREFIX/share/gdal $DEPLOY_DIR/share/
#rsync -ax $PREFIX/share/proj $DEPLOY_DIR/share/

# Get Python version
PYVERSION=$(cat /root/version)
MAJOR=${PYVERSION%%.*}
MINOR=${PYVERSION#*.}
PYVER=${PYVERSION%%.*}.${MINOR%%.*}
PYPATH=/tmp/venv/lib/python${PYVER}/site-packages/

echo Creating deploy package for Python $PYVERSION

EXCLUDE="boto3* botocore* pip* docutils* *.pyc setuptools* wheel* coverage* testfixtures* mock* *.egg-info *.dist-info __pycache__ easy_install.py"

EXCLUDES=()
for E in ${EXCLUDE}
do
    EXCLUDES+=("--exclude ${E} ")
done

# prepare dir for lambda layer deployment - https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html#configuration-layers-path
mkdir -p ./final_deploy/python ./final_deploy/lib ./final_deploy/share
cp -P $DEPLOY_DIR/lib/*.so* ./final_deploy/lib/
rsync -ax $PREFIX/share/gdal ./final_deploy/share/
rsync -ax $PREFIX/share/proj ./final_deploy/share/
rsync -ax $PYPATH/ ./final_deploy/python ${EXCLUDES[@]}
# possible to strip python libraies, instead of doing that monkey business
# find ./final_deploy -type f -iname *.so* -exec strip {} \;
# zip up deploy package
cd ./final_deploy
zip --symlinks -ruq ../lambda-deploy.zip  *

# cleanup
cd ..
rm -rf ./final_deploy
