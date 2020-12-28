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

6. EC2 に Dockerをインストール
- https://qiita.com/shinespark/items/a8019b7ca99e4a30d286
- 上記を参考にただしインストールするcomposeは新しいバージョンを適宜指定する。
```
[root@ip-10-0-10-10 ~]# curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
