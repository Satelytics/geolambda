#!/bin/bash
set -e

echo "Building Python 3.12 layer using PRODUCTION method..."

VERSION=1.0.0
cd python

# Clean up any previous builds
rm -rf lambda-deploy.zip lambda/*

# Build Docker image using production approach (force x86_64 for AWS Lambda compatibility)
echo "Building Docker image with Python 3.12 for x86_64 platform..."
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 -f Dockerfile.py312 \
    -t geolambda-python312-production .

# Run the same packaging script as production (force x86_64 platform)
echo "Running production packaging script..."
docker run --platform linux/amd64 \
    -v ${PWD}:/home/geolambda \
    -t geolambda-python312-production package-python.sh

# Check the result
if [ -f lambda-deploy.zip ]; then
    echo "✅ Production-style build complete!"
    echo "Layer size: $(du -h lambda-deploy.zip | cut -f1)"
    
    # Compare with your current bloated version
    if [ -f ../geolambda/python/lambda-deploy.zip ]; then
        echo "Original bloated size: $(du -h ../geolambda/python/lambda-deploy.zip | cut -f1)"
    fi
    
    # Check if under AWS limit
    SIZE_MB=$(stat -f%z lambda-deploy.zip 2>/dev/null || stat -c%s lambda-deploy.zip)
    SIZE_MB=$((SIZE_MB / 1024 / 1024))
    
    if [ $SIZE_MB -lt 250 ]; then
        echo "🎯 SUCCESS: Layer is ${SIZE_MB}MB (under 250MB AWS limit!)"
        echo "Ready for deployment!"
    else
        echo "⚠️  Layer is ${SIZE_MB}MB (over 250MB limit)"
    fi
    
    echo "Layer contents summary:"
    unzip -l lambda-deploy.zip | head -10
    echo "..."
    echo "$(unzip -l lambda-deploy.zip | tail -1)"
else
    echo "❌ Build failed"
    exit 1
fi