# BIDSKIT v1.3
# MAINTAINER: rnair@caltech.edu | feel free to copy and adapt as needed.
FROM ubuntu:trusty

# Install updates, Python3 for BIDS conversion script, Pip3 for Python to pull the pydicom module
# git and make for building DICOM convertor from source + related dependencies
# Clean up after to keep image size compact!
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential libjpeg-dev python3 python3-pip git cmake pkg-config pigz && \
        apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

# Pull Chris Rorden's dcm2niix latest version from github and compile from source
# - dcm2niix is installed in /usr/local/bin within the container
# - not including support for JPEG2000 (optional -DUSE_OPENJPEG flag)
# - not including support for dcm2niibatch (optional -DBATCH_VERSION flag)
RUN cd /tmp && \
    git clone https://github.com/rordenlab/dcm2niix.git && \
    cd dcm2niix && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make install

# Install python3 bidskit in the container
ADD . /myapp
WORKDIR /myapp
RUN python3 setup.py install