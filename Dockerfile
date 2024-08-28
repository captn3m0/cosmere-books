# LTS Image
FROM ubuntu:22.04

LABEL maintainer="github.cosmere-ebooks@captnemo.in"

ARG DEBIAN_FRONTEND="noninteractive"

COPY Gemfile Gemfile.lock /src/

WORKDIR /src

RUN apt-get update && \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pandoc \
    pdftk-java \
    ruby \
    ruby-dev \
    wget \
    zlib1g-dev \
    python3-xhtml2pdf \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y --purge build-essential \
    && apt-get clean

COPY . /src

ENTRYPOINT ["/src/bootstrap.sh"]

VOLUME ["/output"]
