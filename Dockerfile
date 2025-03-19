
FROM mcr.microsoft.com/devcontainers/cpp:dev-debian12 as build

ARG REL_VER="1.0.0"
ARG AST_VER="22.2.0"
ARG RPT_VER="3.2.0"
ENV REL_VER=$REL_VER
ENV AST_VER=$AST_VER
ENV RPT_VER=$RPT_VER

SHELL ["/bin/bash", "-c"]
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y locales \
    procps git sudo patch apt-utils

RUN sysctl net.ipv6.conf.all.disable_ipv6 && \
    mkdir /workspaces && \
    cd /workspaces && \
    ls -la && \
    git clone https://github.com/AllStarLink/asl3-asterisk.git && \
    ls -la ./asl3-asterisk

WORKDIR /workspaces/asl3-asterisk
RUN ./build-asl3 -l -d /workspaces -a $AST_VER -v $RPT_VER -r $REL_VER source && \
    ./build-asl3 -l -d /workspaces -a $AST_VER -v $RPT_VER -r $REL_VER build

ENV LANG en_US.utf8
