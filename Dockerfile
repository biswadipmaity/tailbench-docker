FROM centos:centos7
MAINTAINER Brian Kocoloski <brian.kocoloski@wustl.edu>

ENV USER cc
ENV HOME /home/${USER}
ENV SSH_DIR ${HOME}/.ssh
ENV JAVA_HOME /etc/elternatives/jre
ENV PATH "/usr/lib64/openmpi/bin:${PATH}"
ENV LD_LIBRARY_PATH "/usr/lib64/openmpi/lib"

RUN yum -y install epel-release && yum -y update
RUN yum -y install openssh-server openssh-clients \
           gperftools google-perftools gcc gcc-c++ make automake wget less file \
           libtool bison autoconf numpy scipy swig ant \
           java-1.8.0-openjdk java-1.8.0-openjdk-devel \
           zlib-devel libuuid-devel opencv-devel jemalloc-devel numactl-devel \
           libdb-cxx-devel libaio-devel openssl-devel readline-devel \
           libgtop2-devel glib-devel python python-devel python-pip openmpi-devel

# Install boost (from SO:
#   https://stackoverflow.com/questions/33050113/how-to-install-boost-devel-1-59-in-centos7
# )
RUN wget ftp://fr2.rpmfind.net/linux/Mandriva/official/2010.0/x86_64/media/main/release/lib64icu42-4.2.1-1mdv2010.0.x86_64.rpm && \
    rpm -ivh lib64icu42-4.2.1-1mdv2010.0.x86_64.rpm && \
    yum -y install boost-devel

# Install py4mpi
RUN pip install --upgrade pip mpi4py

# User creation
RUN useradd ${USER}
RUN mkdir ${SSH_DIR}

# ssh key for openmpi
COPY files/ssh-keys/id_rsa ${SSH_DIR}/id_rsa
COPY files/ssh-keys/id_rsa.pub ${SSH_DIR}/authorized_keys
COPY files/ssh-keys/config ${HOME}/.ssh/config
#COPY files/hostfile ${HOME}/hostfile
RUN chmod -R 700 ${SSH_DIR} && chmod -R 600 ${SSH_DIR}/*

# Copy misc stuff 
COPY files/bashrc ${HOME}/.bashrc
COPY files/bash_profile ${HOME}/.bash_profile

# sshd setup
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''  

# misc stuff
RUN echo "* hard core 0" >> /etc/security/limits.conf
RUN echo "* - fileno 4096" >> /etc/security/limits.conf
RUN echo "root:root" | chpasswd

EXPOSE 2222

# Tailbench specific
RUN mkdir ${HOME}/src
RUN mkdir ${HOME}/data
RUN mkdir ${HOME}/results
RUN mkdir ${HOME}/scratch
RUN mkdir ${HOME}/tailbench-dist
COPY tailbench-dist/* ${HOME}/tailbench-dist/

RUN chown -R ${USER}:${USER} ${HOME}

ENTRYPOINT ["/usr/sbin/sshd", "-D", "-p", "2222"]
