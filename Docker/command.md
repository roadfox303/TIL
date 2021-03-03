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
```
# docker-compose.ymlのあるディレクトリで
$ docker-compose down
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

### コンテナが起動しなくなった時
- コンテナが起動しなくなった場合などは、develop環境なら docker-compose down、docker-compose up、して作成しなおすと手っ取り早い。
- ただし、当然DBは削除されるので、そこだけ注意。安易にproduction環境でやってはいけない。
