ARG VERSION=1.0.0
FROM satelytics/geolambda:${VERSION}

LABEL maintainer="Satelytics"
LABEL authors="John Zhou jzhou@satelytics.com"
#3.7.9
ARG PYVERSION=3.9.9
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
    pip install pip==20.0.2 
    #pip install --upgrade pip
 
COPY requirements*.txt ./


RUN \
    #pip install setuptools==57.5.0; \    
    pip install -r requirements-pre.txt; \
    pip install -r requirements.txt
#RUN export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" && export  AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
#RUN aws s3 cp s3://sioprocess/ripp/releases/latest.tgz . \ 
RUN aws s3 cp s3://sioprocess/ripp/releases/dynamic_import.tgz . \ 
      #&& tar xzvf ./latest.tgz \
      && tar xzvf ./dynamic_import.tgz \
      && cd ripp \
      && pip install PyYAML sh && pip install . \
      && cd .. && rm -rf ripp \
      && rm -rf dynamic_import.tgz

COPY bin/* /usr/local/bin/
