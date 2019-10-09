FROM ubuntu:xenial
MAINTAINER Alexander Paul <alex.paul@wustl.edu>

LABEL \
  description="image to run STIX https://github.com/ryanlayer/stix"
  
RUN apt-get update && apt-get install -y \
  autoconf \
  bzip2 \
  gcc \
  g++ \
  git \
  libbz2-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  liblzma-dev \
  make \
  ncurses-dev \
  ruby \
  wget \
  zlib1g-dev

# add samtools
ENV SAMTOOLS_INSTALL_DIR=/opt/samtools

WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
  tar --bzip2 -xf samtools-1.9.tar.bz2

WORKDIR /tmp/samtools-1.9
RUN ./configure --enable-plugins --prefix=$SAMTOOLS_INSTALL_DIR && \
  make all all-htslib && \
  make install install-htslib

WORKDIR /
RUN ln -s $SAMTOOLS_INSTALL_DIR/bin/samtools /usr/bin/samtools && \
  rm -rf /tmp/samtools-1.9

WORKDIR /opt
# add excord
RUN wget -O excord https://github.com/brentp/excord/releases/download/v0.2.2/excord_linux64 \
  && chmod +x excord \
  && ln -s excord /usr/bin/

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
