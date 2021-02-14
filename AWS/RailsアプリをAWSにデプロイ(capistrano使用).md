### RailsアプリをAWSにデプロイ capistrano
- https://github.com/DaichiSaito/insta_clone/wiki/AWS%E3%81%B8%E3%81%AE%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%EF%BC%88Capistrano%E4%BD%BF%E7%94%A8Ver%EF%BC%89


### 遭遇したエラー
- ATOMのターミナルから cat .ssh/id_rsa.pub で表示し、EC2 の autorized_keys にコピペしたが、エラー。どうも勝手に途中で改行が入っておかしくなる模様。ちゃんとMACのターミナルからコピペすれば問題ない。


### エラーではないが注意する点
- bundle exec cap production custom:start をローカルで実行した際に、.ssh/id_rsa:　のパスフレーズを求められるが、これはアプリ毎のEC2で作成したものとは無関係。いつも git hub に push とかしてるパスワードでいい。ローカルPCが持つssh秘密鍵のパスワードという事だと思う。
```
tNumbuMBP:aws_deploy_app roadfox303$ bundle exec cap production custom:start
Enter passphrase for /Users/roadfox303/.ssh/id_rsa:
```
