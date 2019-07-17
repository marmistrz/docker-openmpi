# Build this image:  docker build -t mpi .
#

FROM ubuntu:18.04
# FROM phusion/baseimage
ENV USER mpirun
ENV HOME=/home/${USER}


# Add an 'mpirun' user
RUN adduser --disabled-password --gecos "" ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install the needed software
RUN apt-get update -y && \
    apt-get -y upgrade && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:marmistrz/openmpi && \
    apt-get install -y \
                        autoconf \
                        build-essential \
                        cmake \
                        git \
                        openssh-server \
                        gcc-8 g++-8 gfortran-8 \
                        libopenmpi-dev openmpi-bin openmpi-common && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 \
                --slave /usr/bin/g++ g++ /usr/bin/g++-8 \
                --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-8 && \
    update-alternatives --config gcc && \
    apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prepare SSHD
RUN sed -i 's/\#Port 22/Port 4222/' /etc/ssh/sshd_config && \
    sed -i 's/\#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/\#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    mkdir /var/run/sshd

# Additional SSH tweaks
ENV SSHDIR ${HOME}/.ssh/
RUN mkdir -p ${SSHDIR} && \
    echo "StrictHostKeyChecking no" > ${SSHDIR}/config && \
    chmod -R 600 ${SSHDIR}* && \
    chown -R ${USER}:${USER} ${SSHDIR}

# Prepare gumpi directories
RUN mkdir /input /output /app && \
    chown mpirun /input /output /app
ENTRYPOINT /usr/sbin/sshd -D

# ------------------------------------------------------------
# Install AMPI
# ------------------------------------------------------------
#RUN cd /opt && \
    #wget http://charm.cs.illinois.edu/distrib/charm-6.8.2.tar.gz && \
    #tar xf charm-6.8.2.tar.gz && \
    #mv charm-v6.8.2 charm && \
#    git clone -b charm --depth 1 https://charm.cs.illinois.edu/gerrit/charm && \
#    cd charm && \
#    ./build AMPI mpi-linux-x86_64 --with-production && \
#    ./build AMPI netlrts-linux-x86_64 --with-production
# We need to use AMPI from git, current release fails big allocations
