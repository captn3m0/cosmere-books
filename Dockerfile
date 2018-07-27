# LTS Image
FROM ubuntu:16.04

LABEL maintainer="github.cosmere-ebooks@captnemo.in"

ARG DEBIAN_FRONTEND="noninteractive"

COPY Gemfile Gemfile.lock /src/

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    calibre \
    pandoc \
    pdftk \
    ruby \
    ruby-dev \
    wget \
    wkhtmltopdf \
    zlib1g-dev \
    && gem install bundler --no-ri --no-rdoc \
    && bundle install \
    && apt-get remove -y --purge build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /src

ENTRYPOINT ["/src/bootstrap.sh"]

VOLUME ["/output"]
