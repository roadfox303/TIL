# Rails入門 Sinatra編

- なぜsinatraか？
  - Railsは便利で素晴らしいフレームワークだが、それゆえに初学者が前提知識を掴みづらく。Railsに使われる状態になりがち。
  - Sinatraはシンプルゆえに基礎や前提知識を学ぶのによい。

### テンプレート読み込み
```
get '/' do #ルートディレクトリ
    erb :index
end
```
- ウェブサイトのルートディレクトリに index.erb を適用している。

### ワークツリーのディレクトリについて
- public ディレクトリは、どのフレームワークでもよく使う。このディレクトリにはファイルを入れただけで簡単に公開されるイメージ。


```
# フォームのアクションの例
# erb
<form action="contacts" method="post">
  <input type="text" name="name">
  <input type="submit">
</form>
```
```
# postを受けるアクションの例
# app.rb
post '/contacts' do
    puts '送信されたデータ'
    p params
    redirect '/'
end
```

### HTTPレスポンスについて
- erb はテンプレートであり、それをベースに処理された結果が html に変換されてレスポンスで返るイメージ。

##### リダイレクト
- リダイレクトされるとき、レスポンスとして Location:/ のような場所を返す。レスポンスを受け取ったブラウザが、そのロケーションに対するリクエストを自動で送る。GET /。
- リダイレクトで戻る場合は必ず GET 通信になる。
- つまりリダイレクトは２回のレスポンスで実現されている。


### Gem管理を行う
- bundler　をインストール
- ワークツリーに新たな Gemfile を作るコマンド
  - bundle init
- ディレクトリ（vender/bandle）を指定してgemをインストールするオプション。
  - bundle install --path vendor/bundle
- bundler　を使用している場合、実行コマンドが下記のように変わる。
  - bundle exec ruby app.rb

### Gem と Bundler
- Gem や Bundler は Ruby に用意された機能なので、Rails　だけでなく、Sinatraなど、Rubyで動いているアプリケーション全てで使える。
- Bundler はたくさんのgemをワンアクションでインストールできる。

### migration 作成
- sinatra（activerecord） のマイグレーションファイル作成コマンドは rails と少し違う。
- bundle exec rake db:create_migration NAME=chenge_usrs_to_users
  - create_migration は マイグレーションファイルを作成しますよというコマンド。
  - NAME=　はマイグレーションの名前。
- マイグレーション ファイルは、グループ開発時などにおいて、DBへの変更を共有するためのファイル。

### ActiveRecord について
- Databaseの操作を ruby から簡単に行う仕組み
- SQLを裏で上手く作成してくれる。SQLが苦手でもある程度扱える。
##### ActiveRecordとDBのCRUD
|CRUD|メソッド|意味|
|:---:|:---:|:---:|
|SELECT|find, all|取得する|
|INSERT|create, save|作成する|
|UPDATE|update, save|更新する|
|DELETE|destroy|削除する|

### MVCの基本
- どうして分けるのか？
  - 変更が激しいViewとそうでないmodelをわけてミスを減らす
  - Viewはデザインの人、modelをロジックの人というふうに分業ができる。
  - 長大なファイルが減ってわかりやすい。
