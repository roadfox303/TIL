# Docker で Rails アプリに Postgresql の RDBMS を構築する。

### docker-compose.yml
1. Railsアプリのルートディレクトリに docker-compose.yml を作成する。
```
version: '3'

services:
  postgres:
      container_name: my-postgres　← コンテナ名
      image: postgres:12　← コンテナイメージ
      ports:
        - "5432:5432"
      environment:
        - POSTGRES_USER=dev　←←← DBユーザー名
        - POSTGRES_PASSWORD=password　← DBパスワード
        - POSTGRES_DB=dev　←←← DBユーザー名
      volumes:
        - ./postgres/initdb:/docker-entrypoint-initdb.d

```

2. database.yml を編集
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: dev ←←←　docker-compose.ymlで設定したユーザー名
  password: password ←←←　docker-compose.ymlで設定したパスワード
  host: localhost
```

3. Dockerコンテナを作成＆起動
```
$ docker-compose up
```

4. db:create
```
$ bundle exec rails db:create
```
