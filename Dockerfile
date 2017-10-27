FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y wget \
                       curl \
                       software-properties-common \
                       git \
                       unzip \
                       postgresql \
                       default-jdk

RUN add-apt-repository ppa:ubuntugis/ppa && apt-get update && apt-get install -y gdal-bin

RUN curl -o /bin/drake https://raw.githubusercontent.com/Factual/drake/master/bin/drake
RUN chmod 755 /bin/drake
CMD ["drake"]

WORKDIR /
RUN git clone https://github.com/dssg/acs2pgsql.git
COPY default_profile /acs2pgsql/default_profile

WORKDIR /acs2pgsql
RUN SHELL=/bin/bash drake --auto
