#installation of ROOT with python 3.6
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

#python 3.6 installation
RUN apt-get update -y && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update -y && \
    apt-get install python3.6 -y

RUN apt-get update -y && \
    apt-get install wget python3-pip git -y 

RUN pip3 install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

#ROOT required packages
RUN apt-get install dpkg-dev cmake g++ gcc binutils libx11-dev \ 
    libxpm-dev libxft-dev libxext-dev python libssl-dev -y
#ROOT other packages
RUN apt-get install gfortran libpcre3-dev \
    xlibmesa-glu-dev libglew1.5-dev libftgl-dev \
    libmysqlclient-dev libfftw3-dev libcfitsio-dev \
    graphviz-dev libavahi-compat-libdnssd-dev \
    libldap2-dev python-dev libxml2-dev libkrb5-dev \
    libgsl0-dev -y

#installation of ROOT 
RUN ROOT_VERSION=6.22.00 && \
    wget https://root.cern/download/root_v$ROOT_VERSION.source.tar.gz && \
    tar -xzvf root_v$ROOT_VERSION.source.tar.gz && \
    rm root_v$ROOT_VERSION.source.tar.gz && \
    CURRENT_PATH=`pwd` && \
    #mkdir ~/root && \
    cd ~/ && \
    mkdir root_$ROOT_VERSION-build root_$ROOT_VERSION-install && \
    cd root_$ROOT_VERSION-build && \
    cmake -DCMAKE_INSTALL_PREFIX=../root_$ROOT_VERSION-install -Dmathmore=ON -Droofit=ON -Dminuit2=ON -Dpyroot=ON -DPython3_EXECUTABLE=/usr/bin/python3.6 $CURRENT_PATH/root-$ROOT_VERSION && \
    #cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -build . -target install -j1 && \
    cmake --build . --target install -- -j9 && \
    cd .. && \
    rm -rf  root_$ROOT_VERSION-build && \
    cd $CURRENT_PATH && \
    rm -rf root-$ROOT_VERSION  