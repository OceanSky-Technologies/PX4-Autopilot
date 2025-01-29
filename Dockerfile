FROM ubuntu:22.04

ENV TERM=xterm-256color
ARG USER
ARG USERID
ARG GROUPID

ENV USER=${USER}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y lsb-release sudo wget \
	&& rm -rf /var/lib/apt/lists/*

# Modify sudoers to allow sudo group members to execute any command without a password
RUN sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

# Create a group and user with the specified IDs, and add the user to the sudo group
RUN groupadd -g ${GROUPID} ${USER} && \
    useradd ${USER} \
    --create-home \
    --uid ${USERID} \
    --gid ${GROUPID} \
    --shell=/bin/bash && \
    adduser ${USER} sudo

USER ${USER}
WORKDIR /home/${USER}/workspace

RUN mkdir setup
COPY ./Tools/setup setup
RUN ./setup/ubuntu.sh && rm -r ./setup

RUN echo '\n# Add red Docker prefix to the terminal\nexport PS1="\[\033[01;31m\][docker] \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/${USER}/.bashrc
