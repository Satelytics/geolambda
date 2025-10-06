#!/bin/bash
set -e

echo "Building Python 3.12 layer using PRODUCTION method on x86_64..."

VERSION=1.0.0
cd python

# Clean up any previous builds
rm -rf lambda-deploy.zip lambda/*

# First build the base geolambda image if it doesn't exist
echo "Checking for geolambda base image..."
if ! docker image inspect geolambda-base:local >/dev/null 2>&1; then
    echo "Building geolambda base image..."
    cd ..
    docker build -t geolambda-base:local .
    cd python
fi

# Build Docker image using production approach (native x86_64)
echo "Building Docker image with Python 3.12 for x86_64 platform..."
docker build -f Dockerfile.py312-clean \
    -t geolambda-python312-production .

# Run the same packaging script as production
echo "Running production packaging script..."
docker run \
    -v ${PWD}:/home/geolambda \
    -t geolambda-python312-production package-python.sh

# Check the result
if [ -f lambda-deploy.zip ]; then
    echo "✅ Production-style build complete!"
    echo "Layer size: $(du -h lambda-deploy.zip | cut -f1)"
    
    # Check if under AWS limit
    SIZE_MB=$(stat -c%s lambda-deploy.zip 2>/dev/null || stat -f%z lambda-deploy.zip)
    SIZE_MB=$((SIZE_MB / 1024 / 1024))
    
    if [ $SIZE_MB -lt 250 ]; then
        echo "🎯 SUCCESS: Layer is ${SIZE_MB}MB (under 250MB AWS limit!)"
        echo "Ready for deployment!"
    else
        echo "⚠️  Layer is ${SIZE_MB}MB (over 250MB limit)"
    fi
    
    # Check if RIPP is included
    echo "Checking for RIPP in layer..."
    if unzip -l lambda-deploy.zip | grep -q "python/ripp/"; then
        echo "✅ RIPP is included in the layer!"
    else
        echo "❌ RIPP is missing from the layer"
    fi
    
    echo "Layer contents summary:"
    unzip -l lambda-deploy.zip | head -10
    echo "..."
    echo "$(unzip -l lambda-deploy.zip | tail -1)"
else
    echo "❌ Build failed"
    exit 1
fi