FROM debian:latest

RUN mkdir /fooocus
RUN apt-get -y update
RUN apt-get -y upgrade

# install build deps (including those needed to compile Python + SciPy)
RUN apt-get -y install git build-essential gfortran pkg-config \
    libopenblas-dev liblapack-dev meson ninja-build \
    wget ca-certificates zlib1g-dev libssl-dev libbz2-dev libreadline-dev \
    libsqlite3-dev libffi-dev libncursesw5-dev libgdbm-dev liblzma-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python 3.10 from source and make it the default python3
ENV PYTHON_VERSION=3.10.14
RUN set -eux; \
    cd /tmp; \
    wget --no-verbose https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz; \
    tar xzf Python-${PYTHON_VERSION}.tgz; \
    cd Python-${PYTHON_VERSION}; \
    ./configure --enable-optimizations --with-ensurepip=install --prefix=/usr/local; \
    make -j"$(nproc)"; \
    make altinstall; \
    rm -rf /tmp/Python-${PYTHON_VERSION}*; \
    ln -sf /usr/local/bin/python3.10 /usr/bin/python3; \
    ln -sf /usr/local/bin/pip3.10 /usr/bin/pip3

RUN cd /fooocus

RUN python3 -m venv /opt/venv
# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

# avoid pip caching very large wheel files (prevents "Memoryview is too large")
ENV PIP_NO_CACHE_DIR=1

#RUN git clone https://github.com/lllyasviel/Fooocus.git
COPY Fooocus /fooocus/Fooocus
RUN cd /fooocus/Fooocus
#COPY ./requirements_versions.txt /fooocus/Fooocus/requirements_versions.txt
RUN pip3 install --no-cache-dir -r /fooocus/Fooocus/requirements_versions.txt
RUN pip3 uninstall -y torch torchvision torchaudio torchtext functorch xformers
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4

WORKDIR /fooocus/Fooocus/
ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 7865

CMD ["python3", "entry_with_update.py", "--listen", "0.0.0.0"]