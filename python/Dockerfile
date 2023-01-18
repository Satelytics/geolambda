ARG VERSION=1.0.0
FROM satelytics/geolambda:${VERSION}

LABEL maintainer="Satelytics"
LABEL authors="John Zhou jzhou@satelytics.com"

ARG PYVERSION=3.7.9
# install Python to system and virtual environment in /tmp/venv
ENV \
    PATH=/tmp/venv/bin:$PATH

RUN \
    cd /tmp; \
    echo  ${PYVERSION} > /root/version; \
    wget https://www.python.org/ftp/python/${PYVERSION}/Python-${PYVERSION}.tgz; \
    tar xzf Python-${PYVERSION}.tgz; \
    cd Python-${PYVERSION}; \
    ./configure --enable-optimizations; \
    make install; \
    cd ..; \
    rm -rf Python-${PYVERSION}; \
    python3 -m venv /tmp/venv; \
    pip install --upgrade pip
 
COPY requirements*.txt ./

RUN \
    pip install -r requirements-pre.txt; \
    pip install -r requirements.txt
#RUN export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" && export  AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
RUN   aws s3 cp s3://sioprocess/ripp/releases/latest.tgz . \ 
      && tar xzvf ./latest.tgz \
      && cd ripp \
      && pip install PyYAML sh && pip install . \
      && cd .. && rm -rf ripp \
      && rm -rf latest.tgz

COPY bin/* /usr/local/bin/
