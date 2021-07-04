https://protocol.nekono.tokyo/2017/02/14/logrotate%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6/

##### logrogtateがインストールされているか確認
```
$ rpm -qa | grep logrotate
  logrotate-3.7.8-26.14.amzn1.x86_64
```
##### 設定ファイル
- 設定の方法は以下のどちらでもよい。
- /etc/logrotate.conf にまとめて書く
- /etc/logrotate.d/syslog のように、logrotate.d以下に、それぞれのログ毎にわけて書く。
```
[ec2-user@ip-10-0-1-30 ~]$ cd /etc/logrotate.d
[ec2-user@ip-10-0-1-30 logrotate.d]$ sudo vi syslog
```

##### コマンド
https://qiita.com/Esfahan/items/a8058f1eb593170855a1

|コマンド|説明|
|:---:|:---|
|compress|ローテーションしたログをgzipで圧縮|
|copytruncate|ログファイルをコピーし、内容を削除|
|create|[パーミッション ユーザー名 グループ名] ローテーション後に空のログファイルを新規作成。ファイルのパーミッション、ユーザー名、グループ名を指定可能|
|daily|ログを毎日ローテーションする|
|delaycompress|ログの圧縮作業を次回のローテーション時まで遅らせる。compressと共に指定|
ifempty|ログファイルが空でもローテーションする|
|missingok|ログファイルが存在しなくてもエラーを出さずに処理を続行|
|monthly|ログを毎月ローテーションする|
|nocompress|ローテーションしたログを圧縮しない|
|nocreate|新たな空のログファイルを作成しない|
|nomissingok|ログファイルが存在しない場合にエラーを出す|
|noolddir|ローテーション対象のログと同じディレクトリにローテーションしたログを格納|
|notifempty|ログファイルが空ならローテーションしない|
|olddir [ディレクトリ名]|指定したディレクトリ内にローテーションしたログを格納|
|postrotate～endscript|postrotateとendscriptの間に記述されたコマンドをログローテーション後に実行|
|prerotate～endscript|prerotateとendscriptの間に記述されたコマンドをログローテーション前に実行|
|rotate 回数|ローテーションする回数を指定|
|size [ファイルサイズ]|ログファイルが指定したファイルサイズ以上になったらローテーションする|
|sharedscripts|複数指定したログファイルに対し、postrotateまたはprerotateで記述したコマンドを実行|
|weekly|ログを毎週ローテーションする|

### postrotate
