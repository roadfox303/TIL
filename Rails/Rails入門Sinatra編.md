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
