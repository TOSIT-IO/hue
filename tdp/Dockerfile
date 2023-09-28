FROM rockylinux:8

RUN yum group install -y "Development Tools"

RUN yum install -y epel-release

RUN yum update -y

RUN yum install -y \
  krb5-devel \
  mariadb-devel \
  openssl-devel \
  cyrus-sasl-devel \
  cyrus-sasl-gssapi \
  sqlite-devel \
  libtidy-devel \
  libxml2-devel \
  libxslt-devel \
  libffi-devel \
  openldap-devel \
  postgresql-devel \
  python38-devel \
  python38-pip \
  python38-setuptools \
  gmp-devel \
  zlib-devel \
  curl \
  maven \
  gcc \
  swig \
  rsync \
  sudo \
  git 

# Need recent version for Ubuntu
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum install -y nodejs

RUN pip3 install --upgrade --no-cache-dir setuptools virtualenv pip 

ENV PYTHON_VER=python3.8

ADD . /hue
RUN mkdir /hue/build 


VOLUME /opt/tdp
WORKDIR /hue
