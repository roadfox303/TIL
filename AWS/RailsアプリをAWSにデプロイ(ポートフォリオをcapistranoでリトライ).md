### 試行錯誤で汚した状態から、capistranoで再度デプロイ
- RDS、EC2、VPCを削除
### VPC作成
- VPCの作成
- サブネットの作成
- インターネットゲートウェイの作成
- ルートテーブルの作成
- セキュリティグループの作成

### RDSインスタンスの作成
- サブネットグループの作成
- RDSインスタンスの作成
### EC2インスタンスの作成
- ElasticIPを設定
- 秘密鍵を .ssh ディレクトリに移動
- 秘密鍵の権限を変更
```
$ chmod 400 petlog-key.pem
```
- EC2の環境設定
```
[ec2-user@ip-10-0-11-189 ~]$ sudo yum -y update
[ec2-user@ip-10-0-11-189 ~]$ sudo adduser roadfox303
[ec2-user@ip-10-0-11-189 ~]$ sudo passwd roadfox303
[ec2-user@ip-10-0-11-189 ~]$ sudo visido
```
```
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
roadfox303  ALL=(ALL)       NOPASSWD: ALL # 追加
```
- 追加したユーザーに変更
```
su - roadfox303
```
- 必要なライブラリのインストール
```
[roadfox303@ip-10-0-11-189 ~]$ sudo yum install \
git make gcc-c++ patch \
openssl-devel \
libyaml-devel libffi-devel libicu-devel \
libxml2 libxslt libxml2-devel libxslt-devel \
zlib-devel readline-devel \
postgresql postgresql-server postgresql-contrib postgresql-devel \
ImageMagick ImageMagick-devel \
epel-release
```
- node.js のインストール
```
[roadfox303@ip-10-0-11-189 ~]$ curl --silent --location https://rpm.nodesource.com/setup_12.x | sudo bash -
[roadfox303@ip-10-0-11-189 ~]$ sudo yum install -y nodejs

# インストールされたか確認
[roadfox303@ip-10-0-11-189 ~]$ which node
```
- yarnの インストール
```
[roadfox303@ip-10-0-11-189 ~]$ curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
[roadfox303@ip-10-0-11-189 ~]$ sudo yum install yarn

# インストールされたか確認
[roadfox303@ip-10-0-11-189 ~]$ which yarn
```
- ruby のインストール
```
[roadfox303@ip-10-0-11-189 ~]$ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
[roadfox303@ip-10-0-11-189 ~]$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
[roadfox303@ip-10-0-11-189 ~]$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
[roadfox303@ip-10-0-11-189 ~]$ source ~/.bash_profile
[roadfox303@ip-10-0-11-189 ~]$ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
[roadfox303@ip-10-0-11-189 ~]$ rbenv install -v 2.6.3
[roadfox303@ip-10-0-11-189 ~]$ rbenv global 2.6.3
[roadfox303@ip-10-0-11-189 ~]$ rbenv rehash
[roadfox303@ip-10-0-11-189 ~]$ ruby -v
```
### Gitとの連携
```
[roadfox303@ip-10-0-11-189 ~]$ cd ~/
[roadfox303@ip-10-0-11-189 ~]$ mkdir .ssh
[roadfox303@ip-10-0-11-189 ~]$ chmod 700 .ssh
[roadfox303@ip-10-0-11-189 ~]$ cd .ssh
[roadfox303@ip-10-0-11-189 .ssh]$ ssh-keygen -t rsa
# Enter passphrase (empty for no passphrase): と Enter same passphrase again: は何も入力せずにエンター

[roadfox303@ip-10-0-11-189 .ssh]$ cat id_rsa.pub
# 表示された文字列をコピー
# GitHub > profileアイコン > settings > SSH and GPG keys
# New SSH key をクリックして、Title と Key(コピーしたrsaキーの中身) を入力。
# Add SSH keyクリックで公開鍵の登録完了。

[roadfox303@ip-10-0-11-189 .ssh]$ cd ~/

# bundler のアップデート
[roadfox303@ip-10-0-11-189 ~]$ gem update bundler

# nginx のインストール
[roadfox303@ip-10-0-11-189 ~]$ sudo amazon-linux-extras install nginx1.12
```

### ローカルの公開鍵をEC2に登録
```
[roadfox303@ip-10-0-11-189 ~]$ touch ~/.ssh/authorized_keys
[roadfox303@ip-10-0-11-189 ~]$ chmod 600 ~/.ssh/authorized_keys
```
- ローカルの公開鍵をコピー
```
tNumbuMBP:~ roadfox303$ cat .ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EA.........省略
# 公開鍵の内容をコピー
```
- コピーした公開鍵をEC2のauthorized_keysに登録
```
[roadfox303@ip-10-0-11-189 ~]$ vim ~/.ssh/authorized_keys
# コピーした公開鍵をペーストして保存
```


### 遭遇した問題やエラー
- capistrano でデプロイが失敗。
  - libcurl が無いとのこと。下記のコマンドでインストール後、デプロイ再実行で解決。
```
[roadfox303@ip-10-0-11-189 ~]$ sudo yum -y install curl
[roadfox303@ip-10-0-11-189 ~]$ sudo yum -y install libcurl libcurl-devel
```

- 環境変数を認識しない。(ArgumentError: Missing required arguments: aws_access_key_id, aws_secret_access_key)
  - carrierwave.rbで参照しているS3用のもの。
- pumaの再起動が分からない。
  - EC2インスタンス上でpumaの再起動を試みたがうまく行かない。
  - ローカルから capistrano のコマンドで再起動すればOK。
  ```
  tNumbuMBP:petlog roadfox303$ bundle exec cap production puma:restart
  ```
