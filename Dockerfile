# LTS Image
FROM ubuntu:18.04

LABEL maintainer="github.cosmere-ebooks@captnemo.in"

ARG DEBIAN_FRONTEND="noninteractive"

COPY . /src/

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    calibre \
    pandoc \
    ruby \
    ruby-dev \
    wget \
    wkhtmltopdf \
    zlib1g-dev \
    && gem install bundler --no-ri --no-rdoc \
    && bundle install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/src/bootstrap.sh", "docker"]

VOLUME ["/output"]
