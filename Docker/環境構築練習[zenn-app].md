# 環境構築練習 zenn-app
##### ● (Dockerfile)ADD Gemfile /app/Gemfile で　エラー
解決法: https://qiita.com/mk-tool/items/1c7e4929055bb3b7aeda

##### ● docker-compose run backend rails new . --api --force --database=mysql --skip-bundle でエラー
- すでに bundler が入っているから？gem install bundler:2.0.1 は不要だった。

  ```
  # エラー内容
  E: Unable to locate package install
  E: Unable to locate package bundler:2.0.1
  E: Couldn't find any package by glob 'bundler:2.0.1'
  E: Couldn't find any package by regex 'bundler:2.0.1'
  ERROR: Service 'backend' failed to build: The command '/bin/sh -c apt-get update -qq &&   apt-get install -y build-essential   libpq-dev   su
  do   gem install bundler:2.0.1' returned a non-zero code: 100
  ```

  ```
  # zenn-app/backend/Dockerfile
  FROM ruby:2.6.6

  ENV LANG C.UTF-8
  ENV TZ Asia/Tokyo

  RUN mkdir /app
  WORKDIR /app

  ADD Gemfile /app/Gemfile

  RUN apt-get update -qq && \
    apt-get install -y build-essential \
    libpq-dev \
    sudo \
    gem install bundler:2.0.1 <<この部分は不要

  RUN bundle install

  ADD . /app
  ```
