
FROM debian:stable as build

ARG REL_VER="1.0.0"
ARG AST_VER="22.2.0"
ARG RPT_VER="3.4.4"
ENV REL_VER=$REL_VER
ENV AST_VER=$AST_VER
ENV RPT_VER=$RPT_VER

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y locales procps git sudo patch apt-utils git && \
    rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.utf8

RUN sysctl net.ipv6.conf.all.disable_ipv6 && \
    mkdir /workspaces && \
    cd /usr/src && \
    ls -la && \
    git clone https://github.com/AllStarLink/asl3-asterisk.git

WORKDIR /usr/src/asl3-asterisk
RUN     /usr/src/asl3-asterisk/install-build-deps && ls -la /usr/src/asl3-asterisk

RUN /usr/src/asl3-asterisk/build-asl3 -l -a $AST_VER -v $RPT_VER -r $REL_VER devmode thin source
RUN /usr/src/asl3-asterisk/build-asl3 -l -a $AST_VER -v $RPT_VER -r $REL_VER devmode thin build && \
    rm -r /usr/src/app_rpt && \
    ln -s /workspaces/app_rpt /usr/src/app_rpt
