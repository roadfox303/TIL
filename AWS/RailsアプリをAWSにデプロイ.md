1. VPCを作成
2. サブネットを作成
  - パブリックサブネット
  - プライベートサブネット
3. ルーティングの設定
- インターネットゲートウェイを作成
  - vpcにアタッチ
- ルートテーブルを作成
  - public route
  - サブネットの関連付け(public-subnet)
  - ルートの作成(0.0.0.0/0 インターネットゲートウェイ)
4. EC2を作成
  - SSHでインスタンスに接続
- AMI
- インスタンスタイプ
- ストレージ
- セキュリティフループの設定
- SSHキーペア




5. RDSを作成
6. ElasticIP
7. ドメインを設定
- ドメインを購入
- Route53でDNSを設定

8. EC2 に Dockerをインストール
- https://qiita.com/shinespark/items/a8019b7ca99e4a30d286
- 上記を参考にただしインストールするcomposeは新しいバージョンを適宜指定する。
```
[root@ip-10-0-10-10 ~]# curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

7. dockerファイル を作成
- アプリのルートディレクトリを作成
```
[ec2-user@ip-10-0-10-10 ~]$ mkdir petlog
[ec2-user@ip-10-0-10-10 ~]$ cd petlog
```
- Nginxコンテナディレクトリの作成
```
[ec2-user@ip-10-0-10-10 petlog]$ mkdir -p containers/nginx
```
- 環境変数用ディレクトリの作成
```
[ec2-user@ip-10-0-10-10 petlog]$ mkdir environments
```
- rails の dockerfile をvimで作成。
  ```
  [ec2-user@ip-10-0-10-10 petlog]$ vim Dockerfile
  ```
  ```
  ### Dockerfile ###

  # 19.01.20現在最新安定版のイメージを取得
  FROM ruby:2.6.3

  # 必要なパッケージのインストール（基本的に必要になってくるものだと思うので削らないこと）
  RUN apt-get update -qq && \
      apt-get install -y build-essential \
                         libpq-dev \
                         nodejs

  # 作業ディレクトリの作成、設定
  RUN mkdir /webapp
  WORKDIR /webapp

  # ホスト側（ローカル）のGemfileを追加する（ローカルのGemfileは【３】で作成）
  ADD ./Gemfile /webapp/Gemfile
  ADD ./Gemfile.lock /webapp/Gemfile.lock

  # Gemfileのbundle install
  RUN bundle install
  ADD . /webapp

  # puma.sockを配置するディレクトリを作成
  RUN mkdir -p tmp/sockets
  ```
- gemfile を作成
  ```
  [ec2-user@ip-10-0-10-10 petlog]$ vim Gemfile
  ```
  ```
  ### gemfile ###

  source 'https://rubygems.org'
  gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
  ```
- gemfile.lock を作成(中身は空で良い)
  ```
  [ec2-user@ip-10-0-10-10 petlog]$ touch Gemfile.lock
  ```
- Nginx用 Dockerfile 作成
  ```
  [ec2-user@ip-10-0-10-10 petlog]$ vim containers/nginx/Dockerfile
  ```
  ```
  ### Dockerfile ###

  FROM nginx:1.15.8

  # インクルード用のディレクトリ内を削除
  RUN rm -f /etc/nginx/conf.d/*

  # Nginxの設定ファイルをコンテナにコピー
  ADD nginx.conf /etc/nginx/conf.d/webbapp.conf

  # ビルド完了後にNginxを起動
  CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
  ```
- Nginx設定ファイル
  ```
  ### nginx.conf ###

  # プロキシ先の指定
  # Nginxが受け取ったリクエストをバックエンドのpumaに送信
  upstream webapp {
    # ソケット通信したいのでpuma.sockを指定
    server unix:///webapp/tmp/sockets/puma.sock;
  }

  server {
    listen 80;
    # ドメインもしくはIPを指定
    server_name petlog.cyou [or 3.113.163.147 [or localhost]];

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;

    # ドキュメントルートの指定
    root /webapp/public;

    client_max_body_size 100m;
    error_page 404             /404.html;
    error_page 505 502 503 504 /500.html;
    try_files  $uri/index.html $uri @webapp;
    keepalive_timeout 5;

    # リバースプロキシ関連の設定
    location @webapp {
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_pass http://webapp;
    }
  }
  ```



- ファイアウォールを設定
- dockerファイルは複数(nginx、postgres、rails、などそれぞれ)に分けて書いても良い。
