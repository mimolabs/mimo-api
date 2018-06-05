FROM ruby:2.5.1

RUN \
  apt-get update && apt-get install -y curl\
  && curl -sL https://deb.nodesource.com/setup_8.x | bash -\
  && apt-get update && apt-get install -y build-essential libpq-dev nodejs nodejs imagemagick\
  && mkdir -p /myapp/public/uploads\
  && npm install -g yarn

WORKDIR /myapp
COPY Gemfile Gemfile.lock /myapp/
RUN bundle install
COPY . /myapp
COPY ./build/puma.rb /myapp/config/puma.rb

EXPOSE 8080
