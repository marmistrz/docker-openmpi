# Build this image:  docker build -t mpi .
#

FROM rastasheep/ubuntu-sshd:18.04
# FROM phusion/baseimage
ENV USER mpirun

ENV HOME=/home/${USER} 


RUN apt update -y && apt upgrade \
    apt install -y build-essential gcc gfortran libopenmpi-dev openmpi-bin openmpi-common openmpi-doc htop && \
    apt clean && apt purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------
# Add an 'mpirun' user
# ------------------------------------------------------------

RUN adduser --disabled-password --gecos "" ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ------------------------------------------------------------
# Set-Up SSH with our Github deploy key
# ------------------------------------------------------------

ENV SSHDIR ${HOME}/.ssh/

RUN mkdir -p ${SSHDIR}

RUN echo "StrictHostKeyChecking no" > ${SSHDIR}/config
ADD ssh/id_rsa.mpi ${SSHDIR}/id_rsa
ADD ssh/id_rsa.mpi.pub ${SSHDIR}/id_rsa.pub
ADD ssh/id_rsa.mpi.pub ${SSHDIR}/authorized_keys

#RUN chmod -R 600 ${SSHDIR}* && \
#    chown -R ${USER}:${USER} ${SSHDIR}
#
