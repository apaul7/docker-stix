FROM ubuntu:xenial
MAINTAINER Alexander Paul <alex.paul@wustl.edu>

LABEL \
  description="image to run STIX https://github.com/ryanlayer/stix"
  
RUN apt-get update && apt-get install -y \
  autoconf \
  gcc \
  git \
  libbz2-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  make \
  ruby \
  wget \
  zlib1g-dev

WORKDIR /opt

## add giggle(find a version?)
RUN git clone https://github.com/ryanlayer/giggle.git \
  && cd giggle \
  && make \
  && ln -s /opt/giggle/bin/giggle /usr/bin/

RUN wget http://www.sqlite.org/2017/sqlite-amalgamation-3170000.zip \
  && unzip sqlite-amalgamation-3170000.zip

## install stix
ENV STIX_COMMIT="68d007b48b405f011a765e446e4935544d404d82"
RUN wget https://github.com/ryanlayer/stix/archive/${STIX_COMMIT}.zip \
  && unzip ${STIX_COMMIT}.zip \
  && mv stix-${STIX_COMMIT} stix \
  && cd stix \
  && make \
  && ln -s /opt/stix/bin/stix /usr/bin/
