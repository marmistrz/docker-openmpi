# Build this image:  docker build -t mpi .
#

FROM rastasheep/ubuntu-sshd:18.04
# FROM phusion/baseimage
ENV USER mpirun

ENV HOME=/home/${USER} 


RUN apt-get update -y && apt-get -y upgrade && \
    apt-get install -y cmake git autoconf build-essential gcc gfortran libopenmpi-dev openmpi-bin openmpi-common openmpi-doc htop && \
    apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------
# Add an 'mpirun' user
# ------------------------------------------------------------

RUN adduser --disabled-password --gecos "" ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ------------------------------------------------------------
# Harden the SSHD configuration
# ------------------------------------------------------------

RUN sed -i 's/\#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/\#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# ------------------------------------------------------------
# Set-Up SSH with our Github deploy key
# ------------------------------------------------------------

ENV SSHDIR ${HOME}/.ssh/

RUN mkdir -p ${SSHDIR}

RUN echo "StrictHostKeyChecking no" > ${SSHDIR}/config
ADD ssh/mpi ${SSHDIR}/id_rsa
ADD ssh/mpi.pub ${SSHDIR}/id_rsa.pub
ADD ssh/mpi.pub ${SSHDIR}/authorized_keys

RUN chmod -R 600 ${SSHDIR}* && \
    chown -R ${USER}:${USER} ${SSHDIR}

# ------------------------------------------------------------
# Install AMPI
# ------------------------------------------------------------
RUN mkdir -p /opt/ampi
RUN cd /opt && \
    #wget http://charm.cs.illinois.edu/distrib/charm-6.8.2.tar.gz && \
    #tar xf charm-6.8.2.tar.gz && \
    #mv charm-v6.8.2 charm && \
    git clone -b charm --depth 1 https://charm.cs.illinois.edu/gerrit/charm && \
    cd charm && \
    ./build AMPI mpi-linux-x86_64 --with-production && \
    ./build AMPI netlrts-linux-x86_64 --with-production
