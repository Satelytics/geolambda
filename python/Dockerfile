ARG VERSION=1.0.0
FROM satelytics/geolambda:${VERSION}

LABEL maintainer="Satelytics"
LABEL authors="John Zhou jzhou@satelytics.com"

ARG PYVERSION=3.7.9

# install Python
ENV \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:/root/.pyenv/bin:$PATH

RUN \
    curl https://pyenv.run | bash; \
    CONFIGURE_OPTS="--with-openssl=${PREFIX}/openssl --enable-loadable-sqlite-extensions" \
        LD_RUN_PATH="${PREFIX}/openssl/lib" \
        pyenv install ${PYVERSION}; \
    pyenv global ${PYVERSION}; \
    pip install --upgrade pip

COPY requirements*.txt ./

RUN \
    pip install -r requirements-pre.txt; \
    pip install -r requirements.txt

COPY bin/* /usr/local/bin/
