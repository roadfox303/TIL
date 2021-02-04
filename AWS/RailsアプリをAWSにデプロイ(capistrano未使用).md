##### 以前はうまくいかなかったのでこちらを参考にした
### RailsアプリをAWSに手動デプロイ
- https://github.com/DaichiSaito/insta_clone/wiki/AWS%E3%81%B8%E3%81%AE%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%EF%BC%88Capistrano%E6%9C%AA%E4%BD%BF%E7%94%A8Ver%EF%BC%89

- mysql ではなく postgres に変えて実装した。
- 概ね根順通りに進んだ。
- database.yml など、本サーバーで手動作成するファイルは、git pull などしたときにコンフリクトを起こすので pullしたい場合は以下の手順。
  ```
  $ git stash save
  $ git pull origin master
  $ git stash pop
  ```
- config/environments/production.rb の以下を変更
  ```
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  これを下記に変更

  config.public_file_server.enabled = true
  ```
- 手動でアセットプリコンパイルする。
- そして puma と nginx を再起動する！再起動しないと色々反映されないのかエラーが出たまま動かない。

### 遭遇したエラー
- Rails new した時点で gemfile.lock にもともとあった msgpack1.4.1 が作者により削除されており、bundle install 時にエラー。
```
Your bundle is locked to msgpack (1.4.1), but that version could not be found in any of the sources listed in your Gemfile. If you haven't changed sources, that means the author of msgpack (1.4.1) has
removed it. You'll need to update your bundle to a version other than msgpack (1.4.1) that hasn't been removed in order to install.
```
```
# 解決策
1. ローカルの gemfile.lock の msgpack(1.4.1) を直接 msgpack(1.4.2)に書き換え
2. bundle update
3. bundle install
```

### 勘違いやミスで間違った事
```
[daichi@ip-10-0-11-177 ~]$ cd /etc/nginx/conf.d
[daichi@ip-10-0-11-177 ~]$ sudo vim ここはアプリ名にする事.conf
```
