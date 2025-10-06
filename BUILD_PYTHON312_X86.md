# Building Python 3.12 Lambda Layer on x86_64

This directory contains files to build a Python 3.12 Lambda layer that matches production size.

## Files Needed on x86_64 Machine:
- `Dockerfile.py312-clean` - Clean Dockerfile for Python 3.12
- `build-python312-clean.sh` - Build script for x86_64
- `requirements-py312.txt` - Python 3.12 compatible packages
- `requirements-pre-py312.txt` - Build dependencies  
- `latest.tgz` - RIPP package (download separately: `wget -O python/latest.tgz https://s3.amazonaws.com/sioprocess/ripp/releases/dynamic_import.tgz`)
- `bin/package-python.sh` - Production packaging script

## Instructions for crystal machine:

### 1. Clone/pull the repository:
```bash
git pull origin main  # or whatever branch you push to
```

### 2. Navigate to the build directory and download RIPP:
```bash
cd og/geolambda
wget -O python/latest.tgz https://s3.amazonaws.com/sioprocess/ripp/releases/dynamic_import.tgz
```

### 3. Run the build (no Python version change needed):
```bash
./build-python312-clean.sh
```

### 4. Expected results:
- Build time: ~25-30 minutes on x86_64
- Layer size: ~80-120MB (under 250MB limit)
- RIPP included: ✅ All modules present
- Python 3.12.7: ✅ Native compilation

## Why x86_64 works better:
- No architecture emulation overhead
- Python compiles with optimizations enabled
- All native extensions compile correctly
- Virtual environment uses actual Python 3.12
- RIPP gets packaged correctly

## Docker requirements on crystal:
- Docker installed and running
- Able to pull from Docker Hub
- ~4GB free space for build process

The host Python version (3.10.12) doesn't matter - everything builds inside Docker containers.