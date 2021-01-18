##### 起動
```
# 本番環境
$ cd /var/www/リポジトリ
$ bundle exec unicorn_rails -c config/unicorn.rb -E production -D
```

##### 停止
```
$ ps -ef | grep unicorn
ec2-user  4185     1  0 17:48 ?        00:00:01 unicorn_rails master -E development -c config/unicorn/development.rb -D
ec2-user  4195  4185  0 17:48 ?        00:00:00 unicorn_rails worker[0] -E development -c config/unicorn/development.rb -D
ec2-user  4196  4185  0 17:48 ?        00:00:00 unicorn_rails worker[1] -E development -c config/unicorn/development.rb -D
ec2-user  4933  3815  0 19:46 pts/0    00:00:00 grep --color=auto unicorn

$ kill -9 4185
# master のプロセスを kill する
```
