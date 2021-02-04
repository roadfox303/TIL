### ４つのパス
- ##### デプロイメントパス(正式名称ではない)
  - **/var/www/petlog** など
  - config/deploy.rb の変数 deploy_to で指定されるもの。
- ##### リリースパス
  - **/var/www/petlog/releases/20210218134209**
  - デプロイメントパスの下層にある releases にタイムスタンプのディレクトリが作られる。
  - デプロイするたびに作成されるので、デプロイ回数と同じ個数だけある。
- ##### 共有パス
  - **/var/www/petlog/shared**
  - デプロイメントパスの下層にある shared ディレクトリ。
  - この下に、bundle、assets、system、log、pidsなどのサブディレクトリが作られ、各リリースを通して共有のファイルが置かれる。
- ##### カレントパス
  - **/var/www/petlog/current**
  - デプロイメントパスの下層にある current ディレクトリ。
  - 実際にはリリースパス（のうちの１つ）へのシンボリックリンク

### デプロイメントの基本的な流れ
capistrano が Railsアプリをデプロイする基本的な流れ
- **Git** の **clone**、**fetch**、**checkout** コマンドなどにより最新のソースコードを取得し、リリースパスにコピーする。
- **bundle install** コマンドを用いて必要なパッケージをインストールする。
- リリースパスの下の適切な場所に、共有パスの各サブディレクトリへのシンボリックリンクを作成する。
- アセットプリコンパイル。
- カレントパスがリリースパスを指すようにシンボリックリンクを作成。
- Rails アプリを再起動。

※UnicornやPassengerとの関係では、カレントパスでRailsアプリが動いていることになるが、ソースコードの実体はリリースパスのディレクトリに存在する。

### 共有パスの役割
##### sharedディレクトリ下の各ディレクトリの役割
|サブディレクトリ|シンボリックリンクのパス|役割|
|:---|:---|:---|
|assets|public/assets|コンパルされたアセットファイル|
|bundle|-|BundlerがGemパッケージをインストールする|
|log|log|Railsアプリケーションが出力するログファイルが置かれる|
|pids|tmp/pids|UnicornのプロセスIDを記録したファイル、**unicorn.pid** が置かれる|
|system|public/system|**maintenance.html** が置かれる|

- bundleディレクトリがあることにより、システム領域でGemを共有するのではなく、アプリのサブディレクトリでGemをインストールするので venber/bundle するのと同じ効果（各アプリで違うバージョンのGemを使える）になる。

### config/deploy/production.rb
```
server "petlog.cyou", # サーバ(EC2など)
  user: "ec2-user", # sshログインに使用するusername
  roles: %w{web app},
  ssh_options: {
    user: "ec2-user", # 必要であれば、ここにuserを書いて上記のuserにオーバーライドできる。
    keys: '~/.ssh/petlog_git_rsa', # ssh秘密鍵のパス
    forward_agent: true,
    auth_methods: %w(publickey password)
    # password: "please use keys"
  }
```
