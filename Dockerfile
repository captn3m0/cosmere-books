# LTS Image
FROM ubuntu:18.04

LABEL maintainer="github.cosmere-ebooks@captnemo.in"

ARG DEBIAN_FRONTEND="noninteractive"

COPY Gemfile Gemfile.lock /src/

WORKDIR /src

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:malteworld/ppa && \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    calibre \
    pandoc \
    pdftk \
    ruby \
    ruby-dev \
    wget \
    wkhtmltopdf \
    xvfb \
    zlib1g-dev \
    && gem install bundler --no-ri --no-rdoc \
    && bundle install \
    && apt-get remove -y --purge build-essential \
    && apt-get clean

COPY . /src

ENTRYPOINT ["/src/bootstrap.sh"]

VOLUME ["/output"]
