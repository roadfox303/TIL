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

8. server から github へ SSH 接続できるようにする
  ```
  [ec2-user@ip-10-0-10-10 ~]$ cd .ssh
  [ec2-user@ip-10-0-10-10 .ssh]$ ssh-keygen -t rsa
  Enter file in which to save the key (/home/ec2-user/.ssh/id_rsa): petlog_git_rsa
  #petlog_git_rsaという名前で鍵を生成

  [ec2-user@ip-10-0-10-10 .ssh]$ ls
  authorized_keys  petlog_git_rsa  petlog_git_rsa.pub
  [ec2-user@ip-10-0-10-10 .ssh]$ cat petlog_git_rsa.pub
  #中身をコピー
  ```
  - Github の profileアイコンのメニュー > Settings > SSH and GPG keys の New SSH key でkeyを新規作成し中身を貼り付ける。

  ```
  [ec2-user@ip-10-0-10-10 .ssh]$ vim config
  -------------------------------------------
  Host github
    Hostname github.com
    User git
    IdentityFile ~/.ssh/petlog_git_rsa (#先ほど作成した秘密鍵のpath)
  -------------------------------------------

  [ec2-user@ip-10-0-10-10 .ssh] $ sudo chmod 600 config
  [ec2-user@ip-10-0-10-10 .ssh] $ ssh -T github

  Warning: Permanently added 'github.com,13.114.40.48' (RSA) to the list of known hosts.
  Hi roadfox303! You've successfully authenticated, but GitHub does not provide shell access.
  # EC2のサーバからGithubへSSH接続成功
  ```

9. EC2インスタンスの環境設定
- 参考：https://qiita.com/Takao_/items/b18234b8db4cda97a113
- 注意)参考URLの例は develop環境 なため、一部 production 環境用に改変が必要。
  ```
  # EC2にログイン
  $ ssh -i aws-test.pem ec2-user@パブリックIPアドレス

  # gitのインストール
  $ sudo yum install git -y

  # node.jsのインストール
  $ sudo rpm -Uvh https://rpm.nodesource.com//pub_10.x/el/6/x86_64/nodejs-10.3.0-1nodesource.x86_64.rpm

  # dependencies for rails のインストール
  $ sudo yum install gcc gcc-c++ libyaml-devel libffi-devel libxml2 libxslt libxml2-devel libslt-devel -y

  # yarn のインストール
  $ sudo npm install yarn  -g

  # yarn のチェックファイル
  $ sudo yarn install --check-files

  # git-core のインストール
  $ sudo yum install git-core

  # rbenvのクローン
  $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv

  # rbenvのpath設定
  $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  $ vi ~/.bash_profile
  ```
  ```
  # .bash_profile

  # Get the aliases and functions
  if [ -f ~/.bashrc ]; then
          . ~/.bashrc
  fi

  # User specific environment and startup programs

  PATH=$PATH:$HOME/.local/bin:$HOME/bin

  export PATH
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"  ← #追加
  ```
  ```
  # bash_profileの反映
  $ source ~/.bash_profile

  # Avoid to Install rb-docs
  $ echo 'gem: --no-document' >> ~/.gemrc

  # ruby-build
  $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

  # dependencies for ruby-build
  $ sudo yum install bzip2 gdbm-devel openssl-devel libffi-devel libyaml-devel ncurses-devel readline-devel zlib-devel -y

  # rubyインストール
  $ RUBY_CONFIGURE_OPTS=--disable-install-doc ~/.rbenv/bin/rbenv install 2.6.3

  # Set default Ruby version
  $ rbenv global 2.6.3 && rbenv rehash

  # bundler のインストール
  $ gem install bundler -v 2.1.0

  # rbenv-rehash
  $ gem install rbenv-rehash

  # rails のインストール
  $ gem install rails -v 5.2.4.3

  # インストールの確認
  $ ruby -v
  ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
  $ rails -v
  Rails 5.2.4.3
  $ bundler -v
  Bundler version 2.1.0
  ```
10. nginx の導入
11. unicorn の導入

- ファイアウォールを設定
- dockerファイルは複数(nginx、postgres、rails、などそれぞれ)に分けて書いても良い。





## AWS＋Nginx＋Unicorn 環境を設定しての デプロイ
参考にした記事
- https://qiita.com/Takao_/items/b18234b8db4cda97a113

## 発生したエラーと解決
##### ec2インスタンスサーバ上での bundle install --path vendor/bundle
1. An error occurred while installing ovirt-engine-sdk (4.4.0), and Bundler cannot continue.
  - https://qiita.com/takahirotakumi1/items/a2241b5cb9da72743f61
2. An error occurred while installing pg (1.2.3), and Bundler cannot continue.
  - https://qiita.com/tdrk/items/812e7ea763080e147757

##### db:create が Connection timed out してしまう。
https://gyazo.com/c2e3a37e7d313bf12ef863b1978ea2e3
- [解決]datebase.yml で指定するエンドポイントが間違っていた。
  - ec2インスタンスのドメインではなく、RDSのエンドポイントを指定する必要がある。awsコンソールで以下の場所で確認できる。
  - RDS > データベース > 指定のインスタンス(db-petlog) > 接続とセキュリティ

##### 記事の通り進めて、アプリのログイン画面まで行ったが、表示がおかしい(css効いてない)＆サインアップするとエラー
- ActionController::InvalidAuthenticityToken

##### credential.yml.enc と master.key を設定していなかった
- credential.yml.enc はハッシュ化されているので、直接編集してはいけない。
```
# このコマンドで編集する
$ sudo EDITOR=vim rails credentials:edit
```
- 本番環境はリモートリポジトリから clone や pull しているので master.key がない(gitignoreしているから)ので下記の方法で設定する。
- 環境変数に記述する方法。https://qiita.com/NaokiIshimura/items/2a179f2ab910992c4d39
- 生成する方法。https://qiita.com/gyu_outputs/items/4653f625ffabc7318a8a
- 今回は環境変数に設定する事にした。

##### secret_key_base を設定していなかった
- 本番環境では必要
https://qiita.com/maru1124_/items/e83f07fbad5ebe4355d1
- 下記のコマンドで出てきたハッシュをコピーしてENVに追加
```
$ bundle exec rake secret
```

##### config/unicorn/production.rb を作成していなかった
- 恐らく config/unicorn.rb に各環境分に記述するなど、いくつかの方法があると思われるが、今回は config/unicorn/development.rb、config/unicorn/production.rb、と分けて記述する。

# 経過
##### 現状
- unicorn.stderr.log で下記のように怒られている。password　が違うという事だが、恐らくは username が root になっていない事が原因。環境変数はrootになっているのだが・・・。
```
I, [2021-01-18T21:05:33.965508 #5563]  INFO -- : unlinking existing socket=/var/www/petlog/tmp/sockets/unicorn.sock
I, [2021-01-18T21:05:33.966336 #5563]  INFO -- : listening on addr=/var/www/petlog/tmp/sockets/unicorn.sock fd=11
E, [2021-01-18T21:05:33.984507 #5563] ERROR -- : FATAL:  password authentication failed for user "petlog"
FATAL:  password authentication failed for user "petlog"
 (PG::ConnectionBad)

```

- 上記のエラー（環境変数系のエラー）で手動デプロイが非常に面倒だったので、capistrano による自動デプロイの準備を整えている。(ローカルで capistrano の各種設定中)
  - 参考：https://qiita.com/ichihara-development/items/1ad4b5d8f29c63bf97f5#nginx
  - 参考：https://bagelee.com/programming/ruby-on-rails/capistrano/
  - 参考：https://qiita.com/tkykmw/items/a34441aae142e0e41b65
