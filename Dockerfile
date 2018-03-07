FROM ubuntu:14.04

ENV SHELL="/bin/bash"

RUN apt-get update && \
    apt-get install -y default-jdk \
                       git \
                       postgresql \
                       unzip \
                       wget

# for gdal
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntugis/ppa && \
    apt-get update && \
    apt-get install -y gdal-bin

RUN wget -O /bin/drake https://raw.githubusercontent.com/Factual/drake/3659c116790f1796261d6d23373de8bba1b663be/bin/drake && \
    chmod 755 /bin/drake

WORKDIR /
RUN wget https://github.com/dssg/acs2pgsql/archive/master.zip && \
    unzip master.zip
COPY default_profile /acs2pgsql-master/

WORKDIR /acs2pgsql-master
ENTRYPOINT ["/bin/drake", "--auto"]
