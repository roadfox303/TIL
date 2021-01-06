##### コンテナの起動
```
$docker container start コンテナ名
```

##### コンテナの停止
```
$docker container stop コンテナ名
```


##### コンテナ一覧の取得
```
$ docker container ls -a

# -a オプションをつけると、起動していない状態のコンテナも表示される。
```

##### コンテナの削除
```
$ docker container rm コンテナ名
```

##### 起動中のコンテナ名確認
```
$ docker-compose ps
```

##### DBコンテナに入る
```
$ docker exec -it DBコンテナ名 bash
```

##### Docker　statusのチェック
```
sudo service docker status
```

##### ネットワークの確認
```
$ docker network ls
```
