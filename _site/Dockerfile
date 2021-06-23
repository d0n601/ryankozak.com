FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install \
git \
libmagickwand-dev \
imagemagick \
pkg-config \
ruby-full \
build-essential \
zlib1g-dev -y && \
gem install "bundler:2.2.10" "jekyll:3.8.6"

EXPOSE 4000

WORKDIR /site

CMD ["sh", "-c", "bundle install && bundle exec jekyll serve --force_polling -H 0.0.0.0 -P 4000"]
