FROM ubuntu:focal-20200319

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    arj \
    cpio \
    gzip \
    lhasa \
    libffi-dev \
    lrzip \
    lzip \
    p7zip-full \
    python-pip-whl \
    python2.7 \
    python3-pip \
    python3.8 \
    unrar \
    wget \
    zip

# Install the python versions
RUN \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
    bash -c "\
        apt-get install -y \
            python2.7{,-dev} \
            python3.6{,-dev} \
            python3.7{,-dev,-distutils} \
            python3.8{,-dev} \
            python3.9{,-dev,-distutils}\
            python3-distutils"

# create a user inside the container. if you specify your UID when building the
# image, you can mount directories into the container with read-write access:
# docker build -t "dtrx" -f Dockerfile --build-arg UID=$(id -u) .
ARG UID=1010
ARG UNAME=builder
RUN useradd --uid ${UID} --create-home --user-group ${UNAME} && \
    echo "${UNAME}:${UNAME}" | chpasswd && adduser ${UNAME} sudo

ENV PATH=${PATH}:/home/${UNAME}/.local/bin

USER ${UNAME}

# Need tox to run the tests, docutils for rst2man.py
RUN pip3 install tox==3.15.2 docutils==0.16

WORKDIR /mnt/workspace
